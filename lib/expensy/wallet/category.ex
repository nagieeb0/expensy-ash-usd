defmodule Expensy.Wallet.Category do
  use Ash.Resource, otp_app: :expensy, domain: Expensy.Wallet, data_layer: AshPostgres.DataLayer

  postgres do
    table "categories"
    repo Expensy.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:name, :description, :monthly_budget]
  end

  validations do
    validate present(:name), message: "Name is required"

    validate present(:monthly_budget),
      message: "Amount is required"

    validate numericality(:monthly_budget, greater_than: 0),
      message: "Budget must be greater than 0"

    validate string_length(:name, min: 1, max: 100)
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :description, :string
    attribute :monthly_budget, :money
    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :expenses, Expensy.Wallet.Expense
  end

  calculations do
    calculate :remaining, :money, expr(monthly_budget - total_spent)
    calculate :is_over_budget?, :boolean, expr(total_spent > monthly_budget)
    calculate :percentage_spent, :money, expr(sum(total_spent) / total_budget)
  end

  aggregates do
    sum :total_spent, :expenses, :amount
    count :expenses_count, :expenses
    max :latest_expense_date, :expenses, :date
  end
end
