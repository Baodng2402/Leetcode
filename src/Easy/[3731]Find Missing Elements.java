/*
 * @lc app=leetcode id=3731 lang=java
 *
 * [3731] Find Missing Elements
 */

// @lc code=start

class Solution {
    public List<Integer> findMissingElements(int[] nums) {
        int max = nums[0];
        int min = nums[0];
        List<Integer> missingElements = new ArrayList<>();

        for (int i = 0; i < nums.length; i++) {
            if (nums[i] > max) {
                max = nums[i];
            }
            if (nums[i] < min) {
                min = nums[i];
            }
        }
        
        for(int x = min + 1; x < max; x++){
            boolean flag = false;
            for(int i = 0; i < nums.length; i++){
                if(nums[i] == x){
                    flag = true;
                    break;
                }
            }
            if(!flag){
                missingElements.add(x);
            }
        }
        return missingElements;
    }
}
// @lc code=end
