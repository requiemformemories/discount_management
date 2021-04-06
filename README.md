# Discount Management

## discounts
discount 包含三個面向：折扣條件、折扣規則
以下是需實作與尚未實作的條件與規則

- [x] 特定商品滿 X 件折 Y 元
    - condition: `{ product: { id: 1, quantity: X } }`
    - rule: `{ amount: Y }`
- [x] 特定商品滿 X 件折 Z %
    - condition: `{ product: { id: 1, quantity: X } }`
    - rule: `{ percent: { value: Z, product_id: 1 } }`
- [x] 訂單滿 X 元折 Y 元
    - condition: `{ all: { amount: X } }`
    - rule: `{ amount: Y }`
- [x] 訂單滿 X 元折 Z %
    - condition: `{ all: { amount: X } }`
    - rule: `{ percent: Z }`
- [ ] 訂單滿 X 元免運費
    - condition: `{ all: { amount: X } }`
    - rule: `{ free_shopping: true }`
- [ ] 訂單滿 X 贈送特定商品
    - condition: `{ all: { amount: X } }`
    - rule: `{ reward: 1 }`
- [x] 特定供應商場品滿 X 件折 Y 元
    - condition: `{ shop: { id: 1, quantity: X } }`
    - rule: `{ amount: Y }`
- [x] 特定供應商場品滿 X 件折 Z %
    - condition: `{ shop: { id: 1, quantity: X } }`
    - rule: `{ percent: { value: Z, product_id: 1 } }`
    - 有可能折 Z% 只折特定供應商場品，有可能是折全部商品，這邊先當成折特定供應商場品的情況
- [ ] 折扣可限定總共只套用 N 次
    - condition: `{ all: { times: N } }`
    - rule:
- [ ] 折扣可限定總共優惠 Y 元
    - condition: `{ all: { amount: Y } }`
    - rule: `{ total_amount: Y }`
    - 折扣 < Y - 現在總優惠金額
    - 要看一下這是一定會跟著某個折扣的條件還是可以 apply 到當前所有折扣上（總折扣不可超過此金額）
    - 另外語意上看不太出來是單筆訂單優惠上限為 Y 元，還是指所有用到優惠的訂單加總不能折超過 Y 元
- [ ] 折扣可限定每人只套用 N 次
    - condition: `{user: { times: N } }`
    - rule:
    - 描述裡面沒有提到折扣條件，應該算是單純的 condition
- [ ] 折扣可限定每人總共優惠 Y 元
    - condition: `{ user: { amount: Y } }`
    - rule: `{ user_total_amount: Y }`
    - 折扣 < Y - 現在總優惠金額
- [x] 折扣可限制特定時間內有效
    - condition: `{ all: { start_at: day1, end_at: day2 } }`
    - rule:
    - 描述裡面沒有提到折扣條件，應該算是單純的 condition
- [ ] 每月重新計算使用數量限制
    - condition: `{ all: { month_times: N } }`
    - rule:  折扣 < Y - 現在總優惠金額

---

## other specs

- [ ] 訂單完成後寄送每人獨立的軟體序號
