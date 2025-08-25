defmodule ExpensyWeb.Categories.FormLive do
  use ExpensyWeb, :live_view

  alias Expensy.Wallet

  def mount(%{"id" => category_id}, _session, socket) do
    category = Wallet.get_category_by_id!(category_id)
    form = Wallet.form_to_update_category(category)

    socket =
      socket
      |> assign(:form, to_form(form))
      |> assign(:category, category)
      |> assign(:page_title, "Wallet - Update category")

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    form = Wallet.form_to_create_category()

    socket =
      socket
      |> assign(:form, to_form(form))
      |> assign(:page_title, "Wallet - New Category")

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
    # amount_str = Map.get(form_data, "monthly_budget")

    # amount =
    #   case Integer.parse(amount_str) do
    #     {val, _} ->
    #       val

    #     :error ->
    #       case Float.parse(amount_str) do
    #         {val, _} -> round(val)
    #         :error -> nil
    #       end
    #   end

    # params = Map.put(form_data, "monthly_budget", amount)
    params = form_data

    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, _category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category created successfully")
         |> push_navigate(to: ~p"/")}

      {:error, form} ->
        {:noreply,
         socket
         |> put_flash(:error, "Can't Save Category")
         |> assign(:form, form)}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        <.h1>
          {@page_title}
        </.h1>

        <.form_wrapper
          id="category_form"
          as={:form}
          for={@form}
          phx-change="validate"
          phx-submit="save"
        >
          <div class="grid lg:grid-cols-1 grid-rows-3 gap-2 p-10">
            <.text_field
              field={@form[:name]}
              space="small"
              color="black"
              label="Name"
              placeholder="Enter category name"
            />
            <.text_field
              field={@form[:description]}
              space="small"
              color="light"
              label="Description"
              placeholder="Category Description"
            />
            <.number_field
              field={@form[:monthly_budget]}
              space="small"
              color="light"
              label="Monthly Budget"
              placeholder="Enter monthly budget amount"
            />
            <%!-- <.number_field
              field={@form[:monthly_budget_amount]}
              space="small"
              color="light"
              label="Monthly Budget"
              placeholder="Enter monthly budget amount"
            /> --%>
            <%!-- <div>
              <div>
                <.radio_card
                  class="py-6"
                  padding="large"
                  cols_gap="large"
                  cols="three"
                  border="medium"
                  field={@form[:monthly_budget_currency]}
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
              </div>
            </div> --%>
          </div>
          <.button type="submit">Save</.button>
          <.button
            phx-click={JS.navigate(~p"/")}
            variant="base"
            color="error"
            size="medium"
          >
            Back to Dashboard
          </.button>
        </.form_wrapper>
      </.header>
    </Layouts.app>
    """
  end
end
