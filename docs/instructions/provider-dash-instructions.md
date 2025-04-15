Absolutely! Here's a **well-structured and optimized prompt** that you can use to guide an AI (like ChatGPT or Codex) or a dev team to implement the `Provider Home Page` based on the detailed GitHub issue you shared.

---

### ✅ Prompt: *Implement Provider Dashboard for TrendyGenie App*

---

You are a senior Flutter developer working on the **TrendyGenie** service platform. Your task is to implement the **Provider Home Page**, which acts as a dashboard for service providers. Use the **MVC architecture**, **GetX** for state management, and respect the app's **custom UI design system** (colors, text styles, button styles).

---

#### 🎯 Objective:
Build a **fully responsive and visually appealing Provider Dashboard** with the following features:

---

### 🧩 1. **Dashboard Metrics (Grid Layout)**  
Implement a metrics section that shows:
- Total number of businesses  
- Total number of sales  
- Total amount generated  
- Total number of clients  

✅ Each metric must appear as a colorful card in a grid layout  
✅ Use shimmer effect while loading  

---

### 🕒 2. **Recent Activities (Last 10 Orders)**  
Display a list of the 10 most recent orders:
- Show: order ID, customer name, order date, order status  
- Styled list items with hover/click feedback  
- Show shimmer loading state before data loads  

---

### 🏢 3. **Business Management Section**  
Display a list of businesses owned by the provider:
- Show: business name, category, and status  
- Include:
  - ➕ A "Create New Business" button
  - ✏️ Edit icon (navigates to edit screen)
  - Clickable row (navigates to detail screen)

💡 Each business may have multiple services.  
✅ Use `BusinessSection` (rename from `ServicesSection`)  

---

### 📄 4. **Business Detail Page**  
When a business is selected, navigate to a detail page with:
- **Tabs:**
  - Orders (paginated + sortable by status)
  - Services (paginated)
- Accept/Reject actions for orders:
  - If *Rejected*, open a form for rejection reason  

✅ Ensure responsive layout for both tabs  
✅ Efficient pagination logic for orders and services  
✅ Use shimmer for loading states  

---

### 🗂️ 5. **Categories Management**  
After loading the dashboard:
- Fetch all business categories using `CategoryController`
- Use them as dropdown/select options in business forms
- Display shimmer while loading categories  

---

### 🎨 6. **Design & UI Guidelines**  
- Use `CustomText` for all text elements  
- Use `CommonButton` for all buttons  
- Apply `firstColor`, `secondColor`, etc. for consistency  
- Ensure the layout works on all screen sizes  
- Use `LoadingShimmer` for placeholders  

---

### 🧠 Implementation Rules  
- Follow MVC structure  
- Build models for all used data (business, order, etc.)  
- Implement proper loading, error, and success states  
- Ensure clear user feedback for all actions  
- Follow `business-services-management.md` logic  

---

### 🔁 Logic Flow Summary  
1. Company signs up  
2. Can create multiple businesses  
3. Each business can have multiple services  
4. Orders are tied to businesses  
5. Orders can be accepted or rejected  

---

### 📊 Data Flow Overview  
1. Load dashboard metrics → show with shimmer  
2. Load recent orders  
3. Fetch business categories  
4. Load provider’s businesses  
5. Load orders and services when viewing a business  

---

### 📱 Screens/sections to Implement /improve 
1. **Provider Dashboard (to improve)**  
2. **Business List View**  
3. **Business Detail View**  
4. **Order Action Modal (Accept/Reject)**  

---

### 📌 Notes  
- Prioritize performance & pagination  
- All actions must show visual feedback  
- Keep UI transitions smooth  
- Ensure code reusability and cleanliness  

---

