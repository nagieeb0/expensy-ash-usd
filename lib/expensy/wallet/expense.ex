defmodule Expensy.Wallet.Expense do
  use Ash.Resource, otp_app: :expensy, domain: Expensy.Wallet, data_layer: AshPostgres.DataLayer

  postgres do
    table "expenses"
    repo Expensy.Repo

    references do
      reference :category, index?: true, on_delete: :delete
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:description, :amount, :date, :notes, :category_id]

    read :recent do
      prepare build(sort: [date: :desc], limit: 10)
    end
  end

  validations do
    validate present(:description), message: "Description is required"
    validate present(:amount), message: "Amount is required"
    validate present(:date), message: "Date is required too!"
    validate present(:category_id), message: "You are missing the category"
    validate compare(:date, less_than_or_equal_to: &Date.utc_today/0)

    validate numericality(:amount, greater_than: 0),
      message: " Amount must be greater than Zero man!"
  end

  attributes do
    uuid_primary_key :id
    attribute :description, :string
    attribute :amount, :money, allow_nil?: false
    attribute :date, :date
    attribute :notes, :string, allow_nil?: true, default: ""
    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :category, Expensy.Wallet.Category, allow_nil?: false
  end

  calculations do
    calculate :is_recent, :boolean, expr(date >= ago(7, :day))
    calculate :is_large_expense, :boolean, expr(amount > 100)
  end
end
