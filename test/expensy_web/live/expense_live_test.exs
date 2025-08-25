defmodule ExpensyWeb.ExpenseLiveTest do
  use ExpensyWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias Expensy.Wallet

  setup do
    {:ok, category} =
      Wallet.create_category(%{name: "Food", monthly_budget: Money.new(:USD, 500)})

    %{category: category}
  end

  #
  # INDEX (via ShowLive)
  #
  describe "Show category with expenses" do
    test "lists expenses inside category show page", %{conn: conn, category: category} do
      {:ok, _} =
        Wallet.create_expense(%{
          description: "Pizza",
          amount: Money.new(:USD, 50),
          date: Date.utc_today(),
          category_id: category.id
        })

      {:ok, _show_live, html} = live(conn, ~p"/categories/#{category.id}")

      assert html =~ "Pizza"
      assert html =~ "$50.00"
    end
  end

  #
  # NEW
  #
  describe "New" do
    test "shows form for new expense", %{conn: conn, category: category} do
      {:ok, new_live, html} = live(conn, ~p"/categories/#{category.id}/expenses/new")

      assert html =~ "New Expense for #{category.name}"
      assert has_element?(new_live, "#expense_form")
    end

    test "creates a new expense", %{conn: conn, category: category} do
      {:ok, new_live, _html} = live(conn, ~p"/categories/#{category.id}/expenses/new")

      form =
        form(new_live, "#expense_form", %{
          "form" => %{
            "description" => "Burger",
            "amount" => "20",
            "date" => Date.to_string(Date.utc_today())
          }
        })

      render_submit(form)

      {:ok, _show_live, html} = live(conn, ~p"/categories/#{category.id}")
      assert html =~ "Burger"
    end
  end

  #
  # EDIT
  #
  describe "Edit" do
    setup %{category: category} do
      {:ok, expense} =
        Wallet.create_expense(%{
          description: "Taxi",
          amount: Money.new(:USD, 30),
          date: Date.utc_today(),
          category_id: category.id
        })

      %{expense: expense}
    end

    test "shows form for editing expense", %{conn: conn, expense: expense} do
      {:ok, edit_live, html} = live(conn, ~p"/expenses/#{expense.id}/edit")

      assert html =~ "Update Expense"
      assert has_element?(edit_live, "#expense_form")
    end

    test "updates an expense", %{conn: conn, category: category, expense: expense} do
      {:ok, edit_live, _html} =
        live(conn, ~p"/expenses/#{expense.id}/edit")

      form =
        form(edit_live, "#expense_form", %{
          "form" => %{
            "description" => "Uber",
            "amount" => "40"
          }
        })

      render_submit(form)

      {:ok, _show_live, html} = live(conn, ~p"/categories/#{category.id}")
      assert html =~ "Uber"
    end
  end

  #
  # DELETE
  #
  describe "Delete" do
    setup %{category: category} do
      {:ok, expense} =
        Wallet.create_expense(%{
          description: "Coffee",
          amount: Money.new(:USD, 10),
          date: Date.utc_today(),
          category_id: category.id
        })

      %{expense: expense}
    end

    test "deletes an expense from category show", %{
      conn: conn,
      category: category,
      expense: expense
    } do
      {:ok, show_live, _html} = live(conn, ~p"/categories/#{category.id}")

      show_live
      |> element("button[phx-click='delete_expense'][phx-value-id='#{expense.id}']")
      |> render_click()

      refute render(show_live) =~ "Coffee"
    end
  end
end
