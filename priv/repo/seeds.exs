# priv/repo/seeds.exs

alias Expensy.Repo
alias Expensy.Wallet

create! = fn resource, attrs ->
  case Ash.create(resource, attrs, repo: Repo) do
    {:ok, record} ->
      record

    {:error, error} ->
      IO.inspect(error, label: "Failed to insert #{resource}")
      raise "Seed failed"
  end
end

# ─────────────────────────────
# Categories
# ─────────────────────────────

food =
  create!.(Wallet.Category, %{
    name: "Food",
    description: "Daily meals, restaurants, coffee",
    monthly_budget: Money.new(:USD, "600.00")
  })

transport =
  create!.(Wallet.Category, %{
    name: "Transport",
    description: "Taxi, metro, bus, Uber",
    monthly_budget: Money.new(:USD, "300.00")
  })

shopping =
  create!.(Wallet.Category, %{
    name: "Shopping",
    description: "Clothes, gadgets, accessories",
    monthly_budget: Money.new(:USD, "1000.00")
  })

entertainment =
  create!.(Wallet.Category, %{
    name: "Entertainment",
    description: "Movies, games, concerts",
    monthly_budget: Money.new(:USD, "400.00")
  })

utilities =
  create!.(Wallet.Category, %{
    name: "Utilities",
    description: "Electricity, internet, water bills",
    monthly_budget: Money.new(:USD, "500.00")
  })

travel =
  create!.(Wallet.Category, %{
    name: "Travel",
    description: "Flights, hotels, trips",
    monthly_budget: Money.new(:USD, "1500.00")
  })

# ─────────────────────────────
# Expenses (Food)
# ─────────────────────────────
create!.(Wallet.Expense, %{
  description: "Lunch at McDonald's",
  amount: Money.new(:USD, "12.50"),
  date: Date.utc_today(),
  notes: "Big Mac menu",
  category_id: food.id
})

create!.(Wallet.Expense, %{
  description: "Pizza Hut dinner",
  amount: Money.new(:USD, "25.00"),
  date: Date.utc_today(),
  notes: "Family size pizza",
  category_id: food.id
})

create!.(Wallet.Expense, %{
  description: "Coffee at Starbucks",
  amount: Money.new(:USD, "6.00"),
  date: Date.utc_today(),
  category_id: food.id
})

create!.(Wallet.Expense, %{
  description: "Groceries - Walmart",
  amount: Money.new(:USD, "80.00"),
  date: Date.utc_today(),
  notes: "Weekly groceries",
  category_id: food.id
})

create!.(Wallet.Expense, %{
  description: "Breakfast sandwich",
  amount: Money.new(:USD, "5.50"),
  date: Date.utc_today(),
  category_id: food.id
})

# ─────────────────────────────
# Expenses (Transport)
# ─────────────────────────────
create!.(Wallet.Expense, %{
  description: "Uber to work",
  amount: Money.new(:USD, "15.00"),
  date: Date.utc_today(),
  category_id: transport.id
})

create!.(Wallet.Expense, %{
  description: "Metro card recharge",
  amount: Money.new(:USD, "30.00"),
  date: Date.utc_today(),
  category_id: transport.id
})

create!.(Wallet.Expense, %{
  description: "Taxi ride",
  amount: Money.new(:USD, "12.00"),
  date: Date.utc_today(),
  category_id: transport.id
})

create!.(Wallet.Expense, %{
  description: "Gas refill",
  amount: Money.new(:USD, "50.00"),
  date: Date.utc_today(),
  notes: "Car fuel",
  category_id: transport.id
})

# ─────────────────────────────
# Expenses (Shopping)
# ─────────────────────────────
create!.(Wallet.Expense, %{
  description: "Bought new iPhone",
  amount: Money.new(:USD, "999.00"),
  date: Date.utc_today(),
  notes: "iPhone 15 Pro",
  category_id: shopping.id
})

create!.(Wallet.Expense, %{
  description: "T-shirt from Zara",
  amount: Money.new(:USD, "25.00"),
  date: Date.utc_today(),
  category_id: shopping.id
})

create!.(Wallet.Expense, %{
  description: "Shoes - Nike Air",
  amount: Money.new(:USD, "120.00"),
  date: Date.utc_today(),
  category_id: shopping.id
})

create!.(Wallet.Expense, %{
  description: "Laptop bag",
  amount: Money.new(:USD, "45.00"),
  date: Date.utc_today(),
  category_id: shopping.id
})

# ─────────────────────────────
# Expenses (Entertainment)
# ─────────────────────────────
create!.(Wallet.Expense, %{
  description: "Cinema tickets",
  amount: Money.new(:USD, "30.00"),
  date: Date.utc_today(),
  notes: "2 tickets IMAX",
  category_id: entertainment.id
})

create!.(Wallet.Expense, %{
  description: "Netflix subscription",
  amount: Money.new(:USD, "15.99"),
  date: Date.utc_today(),
  category_id: entertainment.id
})

create!.(Wallet.Expense, %{
  description: "Concert ticket",
  amount: Money.new(:USD, "120.00"),
  date: Date.utc_today(),
  category_id: entertainment.id
})

# ─────────────────────────────
# Expenses (Utilities)
# ─────────────────────────────
create!.(Wallet.Expense, %{
  description: "Electricity bill",
  amount: Money.new(:USD, "75.00"),
  date: Date.utc_today(),
  category_id: utilities.id
})

create!.(Wallet.Expense, %{
  description: "Internet bill",
  amount: Money.new(:USD, "45.00"),
  date: Date.utc_today(),
  category_id: utilities.id
})

create!.(Wallet.Expense, %{
  description: "Water bill",
  amount: Money.new(:USD, "30.00"),
  date: Date.utc_today(),
  category_id: utilities.id
})

create!.(Wallet.Expense, %{
  description: "Mobile phone bill",
  amount: Money.new(:USD, "60.00"),
  date: Date.utc_today(),
  category_id: utilities.id
})

# ─────────────────────────────
# Expenses (Travel)
# ─────────────────────────────
create!.(Wallet.Expense, %{
  description: "Flight to NYC",
  amount: Money.new(:USD, "450.00"),
  date: Date.utc_today(),
  notes: "Round trip",
  category_id: travel.id
})

create!.(Wallet.Expense, %{
  description: "Hotel booking",
  amount: Money.new(:USD, "700.00"),
  date: Date.utc_today(),
  category_id: travel.id
})

create!.(Wallet.Expense, %{
  description: "Taxi airport",
  amount: Money.new(:USD, "35.00"),
  date: Date.utc_today(),
  category_id: travel.id
})

create!.(Wallet.Expense, %{
  description: "Dinner abroad",
  amount: Money.new(:USD, "60.00"),
  date: Date.utc_today(),
  category_id: travel.id
})

IO.puts("✅ Lots of seeds inserted successfully! Enjoy your dashboard 🚀")
