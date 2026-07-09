/*
 * @lc app=leetcode id=7 lang=java
 *
 * [7] Reverse Integer
 */

// @lc code=start
class Solution {
    public int reverse(int x) {
        int temp = 0;
        while(x != 0){
            int pop = x % 10;
            x /= 10;
            if(temp > Integer.MAX_VALUE/10 || (temp == Integer.MAX_VALUE / 10 && pop > 7)) return 0;
            if(temp < Integer.MIN_VALUE/10 || (temp == Integer.MIN_VALUE / 10 && pop < -8)) return 0;
            temp = temp * 10 + pop;
        }
        return temp;
    }
}
// @lc code=end

