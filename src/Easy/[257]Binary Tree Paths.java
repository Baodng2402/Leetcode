/*
 * @lc app=leetcode id=257 lang=java
 *
 * [257] Binary Tree Paths
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
    public List<String> binaryTreePaths(TreeNode root) {
        List<String> paths = new ArrayList<>();
        dfs(root, paths, "");
        return paths;
        
    }

    public void dfs(TreeNode root, List<String> paths, String path){
        if(root == null) return;
        path += root.val;
        if(root.left == null && root.right == null){
            paths.add(path);
            return;
        }
        path += "->";
        dfs(root.left, paths, path);
        dfs(root.right, paths, path);
    }
}
// @lc code=end

