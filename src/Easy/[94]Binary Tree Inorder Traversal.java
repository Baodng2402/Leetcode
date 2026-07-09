import java.util.*;

class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> result = new ArrayList<>();
        dfs(root, result);
        return result;
    }

    private void dfs(TreeNode node, List<Integer> result){
        if(node == null){
            return;
        }
        dfs(node.left, result);
        result.add(node.val);
        dfs(node.right, result);
    }
}