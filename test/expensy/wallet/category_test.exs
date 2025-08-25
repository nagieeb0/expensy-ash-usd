defmodule Expensy.Wallet.CategoryTest do
  use Expensy.DataCase, async: true
  alias Expensy.Wallet

  #
  # READ
  #
  describe "read_categories/0" do
    test "returns [] when no categories exist" do
      assert Wallet.read_categories!() == []
    end

    test "returns created categories" do
      {:ok, cat1} = Wallet.create_category(%{name: "A", monthly_budget: Money.new(:USD, 100)})
      {:ok, cat2} = Wallet.create_category(%{name: "B", monthly_budget: Money.new(:USD, 200)})

      names = Wallet.read_categories!() |> Enum.map(& &1.name)
      assert Enum.sort(names) == ["A", "B"]
      assert cat1.monthly_budget == Money.new(:USD, 100)
      assert cat2.monthly_budget == Money.new(:USD, 200)
    end
  end

  #
  # CREATE
  #
  describe "create_category/1" do
    test "creates a valid category" do
      {:ok, category} =
        Wallet.create_category(%{
          name: "Food",
          description: "Groceries & restaurants",
          monthly_budget: Money.new(:USD, 500)
        })

      assert category.name == "Food"
      assert category.description == "Groceries & restaurants"
      assert category.monthly_budget == Money.new(:USD, 500)
    end

    test "fails when name is missing" do
      assert {:error, %Ash.Error.Invalid{errors: errors}} =
               Wallet.create_category(%{
                 description: "No name provided",
                 monthly_budget: Money.new(:USD, 200)
               })

      assert Enum.any?(errors, &(&1.message == "Name is required"))
    end

    test "fails when budget is invalid" do
      assert {:error, %Ash.Error.Invalid{errors: errors}} =
               Wallet.create_category(%{
                 name: "Invalid Budget",
                 monthly_budget: Money.new(:USD, -100)
               })

      assert Enum.any?(errors, &(&1.message == "Budget must be greater than 0"))
    end
  end

  #
  # UPDATE
  #
  describe "update_category/2" do
    setup do
      {:ok, category} =
        Wallet.create_category(%{
          name: "Old",
          description: "old desc",
          monthly_budget: Money.new(:USD, 300)
        })

      %{category: category}
    end

    test "updates category fields", %{category: category} do
      {:ok, updated} =
        Wallet.update_category(category, %{
          name: "New",
          description: "new desc",
          monthly_budget: Money.new(:USD, 400)
        })

      assert updated.name == "New"
      assert updated.description == "new desc"
      assert updated.monthly_budget == Money.new(:USD, 400)
    end
  end

  #
  # DELETE
  #
  describe "delete_category/1" do
    test "deletes category successfully" do
      {:ok, category} =
        Wallet.create_category(%{name: "To Delete", monthly_budget: Money.new(:USD, 100)})

      assert :ok = Wallet.delete_category(category)

      assert_raise Ash.Error.Invalid, fn ->
        Wallet.get_category_by_id!(category.id)
      end
    end
  end

  #
  # CALCULATIONS
  #
  describe "calculations" do
    setup do
      {:ok, category} =
        Wallet.create_category(%{
          name: "Transport",
          monthly_budget: Money.new(:USD, 100)
        })

      %{category: category}
    end

    test "total_spent increases when expenses are added", %{category: category} do
      {:ok, _} =
        Wallet.create_expense(%{
          description: "Taxi",
          amount: Money.new(:USD, 30),
          date: Date.utc_today(),
          category_id: category.id
        })

      {:ok, category} = Ash.load(category, [:total_spent])
      assert category.total_spent == Money.new(:USD, 30)
    end

    test "over_budget? is true when expenses exceed budget", %{category: category} do
      {:ok, _} =
        Wallet.create_expense(%{
          description: "Taxi",
          amount: Money.new(:USD, 150),
          date: Date.utc_today(),
          category_id: category.id
        })

      {:ok, category} = Ash.load(category, [:is_over_budget?])
      assert category.is_over_budget? == true
    end
  end
end
