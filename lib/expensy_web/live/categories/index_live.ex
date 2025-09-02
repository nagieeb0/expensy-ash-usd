defmodule ExpensyWeb.Categories.IndexLive do
  # alias Expensy.Wallet.Category
  use ExpensyWeb, :live_view
  alias Expensy.Wallet

  def mount(_, _, socket) do
    categories =
      Wallet.read_categories!(
        load: [
          :remaining,
          :is_over_budget?,
          :total_spent,
          :expenses_count,
          :expenses
        ]
      )

    Enum.each(categories, fn c ->
      if category_percentage(c) >= 100 do
        send(self(), {:budget_reached, c})
      end
    end)

    # totals =
    #   Wallet.totals!()
    total_budget = Ash.sum!(Expensy.Wallet.Category, :monthly_budget)
    total_spent = Ash.sum!(Expensy.Wallet.Expense, :amount)

    socket =
      socket
      |> assign(:categories, categories)
      |> assign(:total_budget, total_budget)
      |> assign(:total_spent, total_spent)
      |> assign(:page_title, "Welcome to Expensy - Best Wallet Manager")

    {:ok, socket}
  end

  defp reload_totals(socket) do
    total_budget = Ash.sum!(Expensy.Wallet.Category, :monthly_budget)
    total_spent = Ash.sum!(Expensy.Wallet.Expense, :amount)

    socket
    |> assign(:total_budget, total_budget)
    |> assign(:total_spent, total_spent)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="flex items-center justify-between w-full">
        <.h1>Dashboard</.h1>
        <.button
          phx-click={JS.navigate(~p"/categories/new")}
          variant="subtle"
          color="success"
          size="medium"
        >
          New Category
        </.button>
      </div>
      <h3>Categories & Expenses Management</h3>

      <.grid cols="one">
        <div class="stats bg-base-100 border-base-300 border">
          <div class="stat">
            <div class="stat-title">Total Balance</div>
            <div class="stat-value text-success ">
              {@total_budget}
            </div>
          </div>
          <div class="stat">
            <div class="stat-title">Total Spent</div>
            <div class="stat-value text-error ">
              {@total_spent}
            </div>
          </div>

          <div class="stat">
            <div class="stat-title">Categories</div>
            <div class="stat-value ">{length(@categories)}</div>
          </div>
        </div>
      </.grid>

      <div class="grid grid-cols-3 gap-2">
        <.flex :for={c <- @categories |> Enum.filter(&(length(&1.expenses) > 0))}>
          <.card padding="small" rounded="large">
            <.card_title>
              <div class="flex items-center justify-between w-full">
                <.link navigate={~p"/categories/#{c.id}/"}>
                  {c.name}
                </.link>

                <.button
                  phx-click="delete_category"
                  phx-value-id={c.id}
                  variant="subtle"
                  color="danger"
                  size="small"
                >
                  Delete
                </.button>
              </div>
            </.card_title>
            <.hr />
            <.card_content class="text-sm">
              <p class="text-xl">
                Budget:
                <span class="text-success">
                  {c.monthly_budget}
                </span>
              </p>
              <p>
                <%= cond do %>
                  <% is_nil(c.remaining) -> %>
                    Remaining: 0
                  <% Money.negative?(c.remaining) -> %>
                    Over budget by
                    <span class="text-error">
                      {c.remaining}
                    </span>
                  <% true -> %>
                    Remaining: {c.remaining}
                <% end %>
              </p>

              <.hr />

              <span>
                <progress
                  class={
                    cond do
                      category_percentage(c) < 60 -> "progress progress-success w-full"
                      category_percentage(c) < 100 -> "progress progress-warning w-full"
                      true -> "progress progress-error w-full"
                    end
                  }
                  max="100"
                  value={category_percentage(c)}
                />
              </span>
              <span>
                {category_percentage(c)} % is consumed
              </span>
            </.card_content>

            <.hr />

            <.card_footer>
              <.button
                phx-click={JS.navigate(~p"/categories/#{c.id}/")}
                class="w-full"
                variant="transparent"
                color="primary"
              >
                Category info
              </.button>
              <.button
                phx-click={JS.navigate(~p"/categories/#{c.id}/expenses/new")}
                class="w-full"
                variant="transparent"
                color="success"
              >
                Add Expense
              </.button>
            </.card_footer>
          </.card>
        </.flex>
      </div>
      
    <!-- Accordion for empty categories -->
      <div
        :if={Enum.any?(@categories, &(length(&1.expenses) == 0))}
        class="collapse collapse-arrow bg-base-100 border border-base-300"
      >
        <input type="checkbox" />
        <div class="collapse-title font-semibold">
          Empty Categories
        </div>
        <div class="collapse-content text-sm">
          <div class="grid grid-cols-3 gap-2">
            <.flex :for={c <- @categories |> Enum.filter(&(length(&1.expenses) == 0))}>
              <.card padding="small" rounded="large">
                <.card_title>
                  <div class="flex items-center justify-between w-full">
                    <.link navigate={~p"/categories/#{c.id}/"}>
                      {c.name}
                    </.link>

                    <.button
                      phx-click="delete_category"
                      phx-value-id={c.id}
                      variant="subtle"
                      color="danger"
                      size="small"
                    >
                      Delete
                    </.button>
                  </div>
                </.card_title>
                <.hr />
                <.card_content class="text-sm">
                  <p class="text-xl">
                    Budget:
                    <span class="text-success">
                      {c.monthly_budget}
                    </span>
                  </p>
                  <p>
                    <%= cond do %>
                      <% is_nil(c.remaining) -> %>
                        Remaining: 0
                      <% Money.negative?(c.remaining) -> %>
                        Over budget by
                        <span class="text-error">
                          {c.remaining}
                        </span>
                      <% true -> %>
                        Remaining: {c.remaining}
                    <% end %>
                  </p>

                  <.hr />

                  <span>
                    <progress
                      class={
                        cond do
                          category_percentage(c) < 60 -> "progress progress-success w-full"
                          category_percentage(c) < 100 -> "progress progress-warning w-full"
                          true -> "progress progress-error w-full"
                        end
                      }
                      max="100"
                      value={category_percentage(c)}
                    />
                  </span>
                  <span>
                    {category_percentage(c)} % is consumed
                  </span>
                </.card_content>

                <.hr />

                <.card_footer>
                  <.button
                    phx-click={JS.navigate(~p"/categories/#{c.id}/")}
                    class="w-full"
                    variant="transparent"
                    color="primary"
                  >
                    Category info
                  </.button>
                  <.button
                    phx-click={JS.navigate(~p"/categories/#{c.id}/expenses/new")}
                    class="w-full"
                    variant="transparent"
                    color="success"
                  >
                    Add Expense
                  </.button>
                </.card_footer>
              </.card>
            </.flex>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  # defp category_percentage(%{total_spent: nil, monthly_budget: %Money{}}), do: 0

  defp category_percentage(%{
         total_spent: %Money{amount: spent},
         monthly_budget: %Money{amount: budget}
       }) do
    if Decimal.compare(budget, 0) == :gt do
      spent
      |> Decimal.mult(100)
      |> Decimal.div(budget)
      |> Decimal.round(0, :half_up)
      |> Decimal.to_integer()
    else
      0
    end
  end

  defp category_percentage(_), do: 0

  def handle_info({:budget_reached, category}, socket) do
    {:noreply, put_flash(socket, :info, "#{category.name} budget is reached!")}
  end

  def handle_event("delete_category", %{"id" => id}, socket) do
    category = Expensy.Wallet.get_category_by_id!(id)

    case Wallet.delete_category(category) do
      :ok ->
        {:noreply,
         socket
         |> assign(
           :categories,
           Wallet.read_categories!(
             load: [:remaining, :is_over_budget?, :total_spent, :expenses_count, :expenses]
           )
         )
         |> reload_totals()
         |> put_flash(:info, "Category deleted successfully")}

      {:ok, _deleted} ->
        {:noreply,
         socket
         |> assign(
           :categories,
           Wallet.read_categories!(
             load: [:remaining, :is_over_budget?, :total_spent, :expenses_count, :expenses]
           )
         )
         |> reload_totals()
         |> put_flash(:info, "Category deleted successfully")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Could not delete category")}
    end
  end
end
