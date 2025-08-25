defmodule Expensy.Wallet do
  use Ash.Domain, otp_app: :expensy, extensions: [AshPhoenix]

  forms do
    form :create_expense, args: [:category_id]
  end

  resources do
    resource Expensy.Wallet.Category do
      define :create_category, action: :create
      define :read_categories, action: :read
      define :update_category, action: :update
      define :delete_category, action: :destroy
      define :get_category_by_id, action: :read, get_by: :id
    end

    resource Expensy.Wallet.Expense do
      define :create_expense, action: :create
      define :update_expense, action: :update
      define :read_expenses, action: :read
      define :delete_expense, action: :destroy
      define :get_expense_by_id, action: :read, get_by: :id
    end
  end
end
