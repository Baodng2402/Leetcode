/*
 * @lc app=leetcode id=69 lang=java
 *
 * [69] Sqrt(x)
 */

// @lc code=start
class Solution {
    public int mySqrt(int x) {
        int left = 1;
        int right = x;
        int result = 0;

        while(left <= right){
            int mid = left + (right - left) / 2;
            if(mid <= x / mid){
                result = mid;
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return result;
    }
}
// @lc code=end

