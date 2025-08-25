 NOTES.md (Ash + LiveView)

 💰 Money / Currency Handling Approach
- Used **AshMoney** extension (`:money` type) for precise currency handling.
- Amounts and budgets stored as money, always backed by `Decimal`.
- Form inputs use `step="0.01"` to prevent float errors.
- **Multi-currency extension plan**:
  - Add a `currency_code` attribute in resources (default `"USD"`).
  - Use Ash `validate_inclusion` to restrict to supported currencies.
  - Add a resource for exchange rates (from an API or manual updates).
  - Ensure all aggregations (totals) are calculated per-currency.

---

 🏗 Architectural Decisions
- Domain: **Wallet** with two core resources: `Category` and `Expense`.
- All business logic is **resource-driven**: validations, constraints, and actions live inside Ash.
- LiveView consumes Ash resources (via AshPhoenix) to remain thin, declarative, and UI-focused.
- Chose **Ash** to demonstrate scalability and clear separation between domain logic and UI.

---

 ⚖️ Trade-offs & Shortcuts
- Delete flows skipped (explicitly out of scope).
- UI kept simple but enhanced with extra effort:
  - Used **Mishka Chelekom UI Components** and **DaisyUI** for better representation of data.
  - This goes beyond the “minimal UI” requirement but provides a polished UX.
- Deferred:
  - Aggregate caching for performance.
  - Spending alerts/analytics (time-limited).

---

 🧪 Testing Strategy
- **Resource tests**: Validations for presence, numericality, and currency inclusion.
- **LiveView tests**: Verified UI updates in real-time when data changes.
- **Workflow tests**: Create Category → Add Expense → Totals update correctly.
- Future work:
  - Integration tests across multiple currencies.
  - Load/performance testing for scalability.

---

 🎨 UI
- Integrated **Mishka Chelekom UI** and **DaisyUI** components.
- Added better layout and styling than required to highlight real-world UX improvements.
- While the brief asked for minimal UI, I invested extra effort here to demonstrate attention to detail.

---

 🔮 Next Steps

1. Implement a currency exchange resource with automatic rate updates.
2. Add advanced analytics (per-category breakdowns, alerts).

---

 📌 Summary
Ash resources encapsulate **business rules** while LiveView handles **real-time rendering**.
Using `AshMoney` makes multi-currency support natural and extendable.
The combination delivers scalability, maintainability, and a stronger user experience than the minimum required.
