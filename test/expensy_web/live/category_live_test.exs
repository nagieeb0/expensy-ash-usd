defmodule ExpensyWeb.CategoryLiveTest do
  use ExpensyWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias Expensy.Wallet

  setup do
    {:ok, category} =
      Wallet.create_category(%{
        name: "Transport",
        monthly_budget: Money.new(:USD, 200)
      })

    %{category: category}
  end

  test "lists categories on dashboard", %{conn: conn, category: category} do
    {:ok, _view, html} = live(conn, ~p"/")

    assert html =~ "Dashboard"
    assert html =~ category.name
  end

  test "shows form for new category", %{conn: conn} do
    {:ok, index_live, _html} = live(conn, ~p"/")

    index_live
    |> element("button", "New Category")
    |> render_click()

    {:ok, form_live, _html} = live(conn, ~p"/categories/new")

    assert has_element?(form_live, "#category_form")
  end

  test "creates a new category", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/categories/new")

    form_data = %{
      "name" => "Food",
      "description" => "Groceries",
      "monthly_budget" => "500"
    }

    {:ok, _, html} =
      view
      |> form("#category_form", form: form_data)
      |> render_submit()
      |> follow_redirect(conn, ~p"/")

    assert html =~ "Food"
    assert html =~ "Category created successfully"
  end

  test "deletes a category from dashboard", %{conn: conn, category: category} do
    {:ok, view, _html} = live(conn, ~p"/")

    view
    |> element("button[phx-value-id='#{category.id}']", "Delete")
    |> render_click()

    assert render(view) =~ "Category deleted successfully"
  end
end
