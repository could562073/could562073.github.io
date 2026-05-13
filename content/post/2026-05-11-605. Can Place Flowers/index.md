+++
title = "605. Can Place Flowers"
date = 2026-05-11
draft = false
tags = ["LeetCode"、"easy"]
categories = ["LeetCode"]
+++

# 605. Can Place Flowers

## 主要用了什麼方法：
for loop

## 用了多久: 
over 30min

## 卡在哪裡：
看了editorial的解答才理解怎麼合理處理邊界問題
處理array邊界的時候不太熟悉，導致再處理index思考過久

## Time Complexity:  
**O(n)**

#### 【推論邏輯】
一個loop

## Space Complexity:  
**O(1)**

#### 【推論邏輯】
一個變數

## My Solution:

```java
class Solution {
    public boolean canPlaceFlowers(int[] flowerbed, int n) {
        int emptyPlots = 0;
        for (int i = 0; i < flowerbed.length; i++) {
            if (flowerbed[i] == 0) {
                boolean emptyLeftPlot = (i == 0) || (flowerbed[i - 1] == 0);
                boolean emptyRightPlot = (i == flowerbed.length - 1) || (flowerbed[i + 1] == 0);
                if (emptyLeftPlot && emptyRightPlot) {
                    flowerbed[i] = 1;
                    emptyPlots++;
                }
            }
        }
        return emptyPlots >= n;
    }
}
```

### 學到什麼：
題目本身不難，但理解題目再要求什麼其實才是最難的 第二次


## accepted
![alt text](image.png)