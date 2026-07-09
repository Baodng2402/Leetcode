class Solution {
    public boolean hasPathSum(TreeNode root, int targetSum) {
        if(root == null) return false;
        return dfs(root, targetSum);
    }

    public boolean dfs(TreeNode root, int targetSum){
        if(root == null) return false;
        if(root.left == null && root.right == null) return targetSum == root.val;
        return dfs(root.left, targetSum - root.val) || dfs(root.right, targetSum - root.val);
    }
}