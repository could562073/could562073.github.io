+++
title = "1431.Kids With the Greatest Number of Candies"
date = 2026-05-08
draft = false
tags = ["LeetCode"]
categories = ["LeetCode"]
+++

# 1431.Kids With the Greatest Number of Candies

## 主要用了什麼方法：
兩個for loop

## 用了多久: 
19m 15s，思考了大概快15分鐘後還是看不懂題目在問的規律，後來看hint 1 後 解出此題

run time時 語法錯誤紀錄:
1.少加;
2.int[].length 是length 不是length()
3.for loop 陣列index out of bound(用了<=

## 卡在哪裡：

看不懂題目問的是要找什麼，找有很多糖果的小孩還是最多糖果的小孩
後面看hint才理解，只要陣列中的小孩擁有最多糖果的那一個，加上extra有大於最多糖果的小孩都算

## Time Complexity:  
兩個for迴圈，n+n=2n

**O(n)**

### 【推論邏輯】
程式碼包含兩個獨立（非巢狀）的 for 迴圈：第一個迴圈：遍歷 candies 陣列找出最大值，執行次數為 $n$（$n$ 為陣列長度）。第二個迴圈：再次遍歷 candies 陣列進行加法比較，執行次數同樣為 $n$。總執行時間為 $n + n = 2n$。在 Big O 表示法中，我們會省略常數係數，因此最終複雜度為 $O(n)$。

    為什麼不是 $O(n^2)$？只有當迴圈裡面「嵌套」另一個迴圈（例如：為了找最大值，每檢查一個元素就重新掃描一遍陣列）時，才會是 $O(n^2)$。

## Space Complexity:  
**O(n)**

### 【推論邏輯】
你建立了一個 ArrayList<Boolean> result。
這個 List 的長度會隨著輸入陣列 candies 的長度 $n$ 等比例增加。
額外的變數 greatestNum 僅佔用 $O(1)$ 常數空間。

## My Solution:

```java
class Solution {
    public String gcdOfStrings(String str1, String str2) {
        String base;
        if (str1.length() > str2.length()) {
            base = str2;
        } else {
            base = str1;
        }
        int minLength = base.length();
        while (minLength > 0) {
            if (gcdStringVerify(base, str1, str2, minLength)) {
                return base;
            }
            minLength--;
            base = base.substring(0, minLength);
        }
        return "";
    }

    public boolean gcdStringVerify(String base, String str1, String str2, int minLength) {
        if (str1.length() % minLength > 0 || str2.length() % minLength > 0) {
            return false;
        } else {
            return str1.replace(base, "").isEmpty() && str2.replace(base, "").isEmpty();
        }
    }
}

```

## Solution By Editorial 

```java
class Solution {
    public boolean valid(String str1, String str2, int k) {
        int len1 = str1.length(), len2 = str2.length();
        if (len1 % k > 0 || len2 % k > 0) {
            return false;
        } else {
            String base = str1.substring(0, k);
            return str1.replace(base, "").isEmpty() && str2.replace(base, "").isEmpty();
        }
    }
    
    
    public String gcdOfStrings(String str1, String str2) {
        int len1 = str1.length(), len2 = str2.length();
        for (int i = Math.min(len1, len2); i >= 1; --i) {
            if (valid(str1, str2, i)) {
                return str1.substring(0, i);
            }
        }
        return "";
    }
}
```

### 學到什麼：

字串處理不夠熟悉，過程中run的時候好幾次提交是因為語法問題，但我想 that's not a problem, because we have AI to coding~