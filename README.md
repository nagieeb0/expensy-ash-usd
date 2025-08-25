 Expensy – Expense Tracker (Ash + LiveView)

Expensy is a simple **expense tracker** built with Phoenix **LiveView**, PostgreSQL, and **Ash Framework**.
This version demonstrates how to implement the tracker in a **resource-driven architecture**, where business logic is expressed through Ash resources and domains.

---

 🚀 Features
- Categories with `name`, `description`, and `monthly_budget` (money/decimal).
- Expenses with `description`, `amount (money/decimal)`, `date`, and optional `notes`.
- Real-time updates using LiveView (totals update immediately when expenses are added).
- Ash resources enforce validations and constraints automatically.
- Totals, remaining budget, and progress bar for each category.
- Seeds for quick demo data.
- **AshMoney** used for precise currency handling.

---

 🛠️ Getting Started

 Prerequisites
- Elixir & Erlang
- PostgreSQL
- Node & npm (for assets)

 Setup
```bash
 Install dependencies & setup DB
mix setup

 Run Ash/Postgres migrations
mix ecto.migrate

 Seed demo data
mix run priv/repo/seeds.exs

 Start the server
mix phx.server
 Visit http://localhost:4000

✅ Testing

mix test
MIX_ENV=test mix test --cover




Tests cover:

    Resource validations and constraints

    LiveView real-time updates

    End-to-end workflow (Category → Expense → Totals/Progress)

    Currency correctness (Decimal & AshMoney)

Project Structure :

lib/
  expensy/
    wallet.ex          Ash Domain
    wallet/            Resources (Category, Expense)
    repo.ex
  expensy_web/
    live/              LiveView screens consuming Ash resources
    components/        UI components
priv/
  repo/migrations/     DB schema with precision/scale & constraints
  repo/seeds.exs
NOTES.md
README.md


🧠 Technical Highlights

Resource-driven: All business logic (validations, actions, calculations) is encapsulated in Ash resources.

Financial Accuracy: AshMoney ensures correct multi-currency handling.

Real-time UX: LiveView makes updates instant without page refresh.

Clean Separation: LiveView handles rendering, Ash handles domain logic.

Production Ready: DB constraints, validations, and tests ensure data integrity.


📄 Notes

See NOTES.md for:

Money/currency handling (with multi-currency extension plan)

Architectural decisions

Trade-offs

Testing strategy


🔑 License

MIT
