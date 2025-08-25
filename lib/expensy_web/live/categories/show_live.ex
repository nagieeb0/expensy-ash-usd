defmodule ExpensyWeb.Categories.ShowLive do
  use ExpensyWeb, :live_view
  alias Expensy.Wallet

  def mount(%{"id" => category_id}, _session, socket) do
    category = Wallet.get_category_by_id!(category_id, load: [:expenses])

    socket =
      socket
      |> assign(:category, category)
      |> assign(:page_title, "Category #{category.name}")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="flex items-center justify-between w-full">
        <.badge variant="shadow" size="large" color="primary">Category information</.badge>
        <.button
          phx-click={JS.navigate(~p"/")}
          variant="default"
          color="success"
          size="medium"
        >
          Back to Dashboard
        </.button>
      </div>
      <.header>
        <.h1>{@category.name}</.h1>
        <:subtitle>
          {length(@category.expenses)} expense(s) in this category
        </:subtitle>
      </.header>

      <.table
        :if={Kernel.length(@category.expenses) > 0}
        header_border="extra_small"
        rows_border="extra_small"
        cols_border="extra_small"
      >
        <:header>Expense Desc</:header>
        <:header>Amount</:header>
        <:header>Notes</:header>
        <:header>Date</:header>
        <:header>Actions</:header>

        <.tr :for={expense <- @category.expenses}>
          <.td>{expense.description}</.td>
          <.td>
            {expense.amount}
          </.td>
          <.td>{expense.notes}</.td>
          <.td>{expense.date}</.td>
          <.td class="flex">
            <.link navigate={~p"/expenses/#{expense.id}/edit"}>
              <.button size="small" variant="subtle" color="success">
                Edit
              </.button>
            </.link>

            <.button
              phx-click="delete_expense"
              phx-value-id={expense.id}
              size="small"
              variant="subtle"
              color="danger"
            >
              Delete
            </.button>
          </.td>
        </.tr>
      </.table>
    </Layouts.app>
    """
  end

  def handle_event("delete_expense", %{"id" => expense_id}, socket) do
    case Wallet.delete_expense(expense_id) do
      :ok ->
        category = Wallet.get_category_by_id!(socket.assigns.category.id, load: [:expenses])

        {:noreply,
         socket
         |> assign(:category, category)
         |> put_flash(:info, "Expense deleted successfully")}

      {:ok, _} ->
        category = Wallet.get_category_by_id!(socket.assigns.category.id, load: [:expenses])

        {:noreply,
         socket
         |> assign(:category, category)
         |> put_flash(:info, "Expense deleted successfully")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to delete expense")}
    end
  end
end
