defmodule ExpensyWeb.Expenses.FormLive do
  use ExpensyWeb, :live_view
  alias Expensy.Wallet

  def mount(%{"id" => expense_id}, _session, socket) do
    expense = Wallet.get_expense_by_id!(expense_id, load: [:category])

    # amount_value = expense.amount.amount
    # amount_currency = expense.amount.currency

    pre_filled_data = %{
      "description" => expense.description,
      "amount" => expense.amount,
      # "amount_currency" => amount_currency,
      "date" => expense.date,
      "notes" => expense.notes,
      "category_id" => expense.category_id
    }

    form = Wallet.form_to_update_expense(expense, params: pre_filled_data)

    socket =
      socket
      |> assign(:form, to_form(form))
      |> assign(:category, expense.category)
      |> assign(:page_title, "Update Expense for #{expense.category.name}")

    {:ok, socket}
  end

  def mount(%{"category_id" => category_id}, _session, socket) do
    category = Wallet.get_category_by_id!(category_id)
    form = Wallet.form_to_create_expense(category.id)

    socket =
      socket
      |> assign(:form, to_form(form))
      |> assign(:category, category)
      |> assign(:page_title, "New Expense for #{category.name}")

    {:ok, socket}
  end

  def handle_event("validate", %{"form" => form_data}, socket) do
    socket =
      update(socket, :form, fn form ->
        AshPhoenix.Form.validate(form, form_data)
      end)

    {:noreply, socket}
  end

  def handle_event("save", %{"form" => form_data}, socket) do
    # amount =
    #   form_data |> Map.get("amount") |> to_string() |> Float.parse("") |> Float.ceil() |> trunc()

    # currency = Map.get(form_data, "amount_currency")
    # money_value =
    # %{"amount" => amount, _
    # # "currency" => currency
    # }
    # params = Map.put(form_data, "amount", amount)

    # Submit the form data to Ash
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_data) do
      {:ok, _expense} ->
        socket
        |> put_flash(:info, "Expense Saved!")
        |> push_navigate(to: ~p"/categories/#{socket.assigns.category.id}")
        |> then(&{:noreply, &1})

      {:error, form} ->
        socket
        |> put_flash(:error, "Could not save expense.")
        |> assign(:form, form)
        |> then(&{:noreply, &1})
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="container mx-auto p-4">
        <h1 class="text-3xl font-bold mb-4">{@page_title}</h1>

        <.form_wrapper
          id="expense_form"
          as={:form}
          for={@form}
          phx-change="validate"
          phx-submit="save"
        >
          <div class="space-y-4">
            <.text_field
              field={@form[:description]}
              label="Description"
              placeholder="e.g., Groceries"
            />
            <.number_field
              field={@form[:amount]}
              label="Amount"
              placeholder="50"
            />
            <%!-- <.number_field
              field={@form[:amount_amount]}
              label="Amount"
              placeholder="e.g., 50.00"
            /> --%>
            <.date_time_field
              field={@form[:date]}
              label="Date"
              type="date"
              max={Date.utc_today()}
            />

            <.text_field
              field={@form[:notes]}
              label="Notes"
              placeholder="Optional notes"
            />
            <div class="hidden">
              <.input field={@form[:category_id]} />
            </div>
            <%!-- <div>
              <.radio_card
                class="py-6"
                padding="large"
                cols_gap="large"
                cols="three"
                border="medium"
                field={@form[:amount_currency]}
              >
                <:radio description="United States Dollar" value="USD" title="USD">
                  <svg
                    data-slot="icon"
                    aria-hidden="true"
                    fill="none"
                    stroke-width="1.5"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                    class="h-6 w-6"
                  >
                    <path
                      d="M12 6v12m-3-2.818.879.659c1.171.879 3.07.879 4.242 0 1.172-.879 1.172-2.303 0-3.182C13.536 12.219 12.768 12 12 12c-.725 0-1.45-.22-2.003-.659-1.106-.879-1.106-2.303 0-3.182s2.9-.879 4.006 0l.415.33M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    >
                    </path>
                  </svg>
                </:radio>
                <:radio description="Euro" value="EUR" title="EUR">
                  <svg
                    data-slot="icon"
                    aria-hidden="true"
                    fill="none"
                    stroke-width="1.5"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                    class="h-6 w-6"
                  >
                    <path
                      d="M14.25 7.756a4.5 4.5 0 1 0 0 8.488M7.5 10.5h5.25m-5.25 3h5.25M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    >
                    </path>
                  </svg>
                </:radio>
                <:radio description="Great British Pound" value="GBP" title="GBP">
                  <svg
                    data-slot="icon"
                    aria-hidden="true"
                    fill="none"
                    stroke-width="1.5"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                    class="h-6 w-6"
                  >
                    <path
                      d="M14.121 7.629A3 3 0 0 0 9.017 9.43c-.023.212-.002.425.028.636l.506 3.541a4.5 4.5 0 0 1-.43 2.65L9 16.5l1.539-.513a2.25 2.25 0 0 1 1.422 0l.655.218a2.25 2.25 0 0 0 1.718-.122L15 15.75M8.25 12H12m9 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    >
                    </path>
                  </svg>
                </:radio>
              </.radio_card>
            </div> --%>
          </div>

          <div class="mt-6 flex gap-2">
            <.button type="submit" phx-disable-with="Saving...">Save</.button>
            <.button
              phx-click={JS.navigate(~p"/categories/#{@category.id}")}
              variant="base"
              color="error"
              size="medium"
            >
              Back to {@category.name} Category
            </.button>
          </div>
        </.form_wrapper>
      </div>
    </Layouts.app>
    """
  end
end
