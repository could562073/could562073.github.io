+++
title = "392. Is Subsequence"
date = 2026-05-22
draft = false
tags = ["LeetCode", "easy"]
categories = ["LeetCode"]
+++

# 392. Is Subsequence

![alt text](image.png)

## 主要用了什麼方法：
指針移動 while

## 用了多久: 
15 min

## 卡在哪裡：
指針題型已經逐漸熟練，這次沒卡，不過邊界忘了處理，後來補上才過
且常常有基礎語法錯誤，還是要盡量避免run的時候一直出現語法錯誤

## Time Complexity:  
**O(n)**

## Space Complexity:  
**O(n)**

## My Solution:
```java
class Solution {
    public boolean isSubsequence(String s, String t) {
        if(s.length() < 1) return true;
        if(s.length() >= 1 && t.length() < 1) return false;
        int i = 0;
        int sCount = 0;
        char[] sc = s.toCharArray();
        char[] st = t.toCharArray();
        while(i < t.length()){
            if(st[i] == sc[sCount]){
                sCount++;
                if(sCount == s.length()){
                    return true;
                }
            }
            i++;
        }
        return false;
    }
}
```

### 學到什麼：
1. 邊界處理
2. 基礎語法error需要盡量避免

## Accepted

![alt text](image-1.png)