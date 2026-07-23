/*
 * @lc app=leetcode id=144 lang=java
 *
 * [144] Binary Tree Preorder Traversal
 */

// @lc code=start
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode() {}
 *     TreeNode(int val) { this.val = val; }
 *     TreeNode(int val, TreeNode left, TreeNode right) {
 *         this.val = val;
 *         this.left = left;
 *         this.right = right;
 *     }
 * }
 */
class Solution {
    public List<Integer> preorderTraversal(TreeNode root) {
        List<Integer> num = new ArrayList<>();
        dfs(root, num);
        return num;
    }

    public void dfs(TreeNode root, List<Integer> num){
        if(root == null) return;
        num.add(root.val);
        dfs(root.left, num);
        dfs(root.right, num);
    }
}
// @lc code=end

