defmodule Expensy.Wallet.ExpenseTest do
  use Expensy.DataCase, async: true
  alias Expensy.Wallet

  #
  # READ
  #
  describe "read_expenses/0" do
    test "returns [] when no expenses exist" do
      assert Wallet.read_expenses!() == []
    end

    test "returns created expenses" do
      {:ok, cat} =
        Wallet.create_category(%{name: "Food", monthly_budget: Money.new(:USD, 100)})

      {:ok, exp1} =
        Wallet.create_expense(%{
          description: "Lunch",
          amount: Money.new(:USD, 20),
          date: Date.utc_today(),
          category_id: cat.id
        })

      {:ok, exp2} =
        Wallet.create_expense(%{
          description: "Dinner",
          amount: Money.new(:USD, 30),
          date: Date.utc_today(),
          category_id: cat.id
        })

      descs = Wallet.read_expenses!() |> Enum.map(& &1.description)
      assert Enum.sort(descs) == ["Dinner", "Lunch"]
      assert exp1.amount == Money.new(:USD, 20)
      assert exp2.amount == Money.new(:USD, 30)
    end
  end

  #
  # CREATE
  #
  describe "create_expense/1" do
    setup do
      {:ok, category} =
        Wallet.create_category(%{
          name: "Transport",
          monthly_budget: Money.new(:USD, 200)
        })

      %{category: category}
    end

    test "creates a valid expense", %{category: category} do
      {:ok, expense} =
        Wallet.create_expense(%{
          description: "Taxi",
          amount: Money.new(:USD, 50),
          date: Date.utc_today(),
          category_id: category.id
        })

      assert expense.description == "Taxi"
      assert expense.amount == Money.new(:USD, 50)
      assert expense.category_id == category.id
    end

    test "fails when description is missing", %{category: category} do
      assert {:error, %Ash.Error.Invalid{errors: errors}} =
               Wallet.create_expense(%{
                 amount: Money.new(:USD, 50),
                 date: Date.utc_today(),
                 category_id: category.id
               })

      assert Enum.any?(errors, &(&1.message == "Description is required"))
    end

    test "fails when amount <= 0", %{category: category} do
      assert {:error, %Ash.Error.Invalid{errors: errors}} =
               Wallet.create_expense(%{
                 description: "Invalid Expense",
                 amount: Money.new(:USD, 0),
                 date: Date.utc_today(),
                 category_id: category.id
               })

      assert Enum.any?(errors, &(&1.message == " Amount must be greater than Zero man!"))
    end
  end

  #
  # UPDATE
  #
  describe "update_expense/2" do
    setup do
      {:ok, category} =
        Wallet.create_category(%{
          name: "Bills",
          monthly_budget: Money.new(:USD, 300)
        })

      {:ok, expense} =
        Wallet.create_expense(%{
          description: "Internet Bill",
          amount: Money.new(:USD, 100),
          date: Date.utc_today(),
          category_id: category.id
        })

      %{expense: expense}
    end

    test "updates expense fields", %{expense: expense} do
      {:ok, updated} =
        Wallet.update_expense(expense, %{
          description: "Updated Bill",
          amount: Money.new(:USD, 150)
        })

      assert updated.description == "Updated Bill"
      assert updated.amount == Money.new(:USD, 150)
    end
  end

  #
  # DELETE
  #
  describe "delete_expense/1" do
    test "deletes expense successfully" do
      {:ok, category} =
        Wallet.create_category(%{name: "Misc", monthly_budget: Money.new(:USD, 100)})

      {:ok, expense} =
        Wallet.create_expense(%{
          description: "To Delete",
          amount: Money.new(:USD, 10),
          date: Date.utc_today(),
          category_id: category.id
        })

      assert :ok = Wallet.delete_expense(expense)

      assert_raise Ash.Error.Invalid, fn ->
        Wallet.get_expense_by_id!(expense.id)
      end
    end
  end
end
