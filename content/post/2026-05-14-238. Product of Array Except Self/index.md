+++
title = "238. Product of Array Except Self"
date = 2026-05-14
draft = false
tags = ["LeetCode"、"meduim"]
categories = ["LeetCode"]
+++

# 238. Product of Array Except Self

## 題目要求

給定一個整數陣列 `nums`，回傳一個陣列 `answer`，使得 `answer[i]` 等於 `nums` 中**除了 `nums[i]` 之外**所有元素的乘積。

- 不能使用除法
- 時間複雜度必須是 O(n)

---

## 暴力解（會超時）

### 思路

對每個位置 `i`，用內層迴圈把其他所有元素乘起來。

```java
while (i < nums.length) {
    int countNum = 1;
    int k = 0;
    while (k < nums.length) {
        if (k != i) {
            countNum *= nums[k];
        }
        k++;
    }
    answer[i] = countNum;
    i++;
}
```

### 問題

| 問題 | 說明 |
|---|---|
| 時間複雜度 O(n²) | 兩層迴圈，資料大時超時 |
| 邏輯 bug | 用值比較跳過自己，遇到重複數字會連帶跳掉 |

---

## 優化思路拆解

### 觀察：大量重複計算

計算 `answer[2]` 和 `answer[3]` 時，左邊的乘積幾乎一樣，只差一個數字。

> **訊號：有大量重複計算 → 能不能把上一步的結果存起來，下一步直接用？**

### 核心拆解

對任意位置 `i`：

```
answer[i] = (i 左邊所有元素的乘積) × (i 右邊所有元素的乘積)
```

所以可以拆成兩次單向掃描：

```
第一次掃描（左 → 右）：把每個位置的「左積」存進 answer
第二次掃描（右 → 左）：用一個變數追蹤「右積」，乘上去得到最終答案
```

---

## 最優解步驟拆解

以 `nums = [1, 2, 3, 4]` 為例。

### Step 1：初始化

```
answer[0] = 1
```

索引 0 的左邊沒有元素，左積為 1（空積定義為 1）。

### Step 2：向右掃描，累積左積

公式：`answer[i] = nums[i-1] × answer[i-1]`

| i | 計算過程 | answer |
|---|---|---|
| 1 | `nums[0] × answer[0]` = 1 × 1 = 1 | [1, **1**, ?, ?] |
| 2 | `nums[1] × answer[1]` = 2 × 1 = 2 | [1, 1, **2**, ?] |
| 3 | `nums[2] × answer[2]` = 3 × 2 = 6 | [1, 1, 2, **6**] |

此時 `answer` 存的是每個位置的**左積**。

### Step 3：初始化 rightProduct

```
rightProduct = 1
```

最後一個位置的右邊沒有元素，右積為 1。

### Step 4：向左掃描，乘上右積

公式：
```
answer[i] = answer[i] × rightProduct
rightProduct = rightProduct × nums[i]   // 更新給下一輪用
```

| i | 計算過程 | rightProduct 更新 | answer |
|---|---|---|---|
| 3 | 6 × 1 = **6** | 1 × 4 = 4 | [1, 1, 2, **6**] |
| 2 | 2 × 4 = **8** | 4 × 3 = 12 | [1, 1, **8**, 6] |
| 1 | 1 × 12 = **12** | 12 × 2 = 24 | [1, **12**, 8, 6] |
| 0 | 1 × 24 = **24** | 24 × 1 = 24 | [**24**, 12, 8, 6] |

### 驗證

| 位置 | 計算 | 結果 |
|---|---|---|
| answer[0] | 2 × 3 × 4 | 24 ✓ |
| answer[1] | 1 × 3 × 4 | 12 ✓ |
| answer[2] | 1 × 2 × 4 | 8 ✓ |
| answer[3] | 1 × 2 × 3 | 6 ✓ |

---

## 最終程式碼

```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int n = nums.length;
        int[] answer = new int[n];

        // Step 1 & 2：初始化並向右掃描，存左積
        answer[0] = 1;
        for (int i = 1; i < n; i++) {
            answer[i] = nums[i - 1] * answer[i - 1];
        }

        // Step 3 & 4：向左掃描，乘上右積
        int rightProduct = 1;
        for (int i = n - 1; i >= 0; i--) {
            answer[i] = answer[i] * rightProduct;
            rightProduct *= nums[i];
        }

        return answer;
    }
}
```

---

## 複雜度分析

| | 複雜度 | 說明 |
|---|---|---|
| 時間 | O(n) | 兩次單向掃描 |
| 空間 | O(1) | 只用一個 `rightProduct` 變數，output 陣列不算額外空間 |

---

## 學習重點

- 看到兩層迴圈，先問自己：**「有沒有大量重複計算？」**
- 相鄰子問題之間有關聯時，考慮**把上一步結果存起來**（前綴思想）
- **從兩個方向各掃一次**，是很多陣列題的經典模式