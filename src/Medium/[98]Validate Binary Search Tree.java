/*
 * @lc app=leetcode id=98 lang=java
 *
 * [98] Validate Binary Search Tree
 */

// @lc code=start

import java.util.List;

/**
 * Definition for a binary tree node.
 * public class TreeNode {
 * int val;
 * TreeNode left;
 * TreeNode right;
 * TreeNode() {}
 * TreeNode(int val) { this.val = val; }
 * TreeNode(int val, TreeNode left, TreeNode right) {
 * this.val = val;
 * this.left = left;
 * this.right = right;
 * }
 * }
 */
class Solution {
    public boolean isValidBST(TreeNode root) {
        List<Integer> nums = new ArrayList<>();
        dfs(root, nums);
        for (int i = 0; i < nums.size() - 1; i++) {
            if (nums.get(i) >= nums.get(i + 1))
                return false;
        }
        return true;
    }

    public void dfs(TreeNode root, List<Integer> nums) {
        if (root == null) return;
        dfs(root.left, nums);
        nums.add(root.val);
        dfs(root.right, nums);
    }
}
// @lc code=end
