class Solution {
    public List<List<Integer>> generate(int numRows) {
        List<List<Integer>> result = new ArrayList<>();
        for(int i = 1; i <= numRows; i++){
            result.add(generateRow(i));
        }
        return result;
    }

    public List<Integer> generateRow(int row){
        List<Integer> currentRow = new ArrayList<>();
        currentRow.add(1);
        for(int i = 1; i < row; i++){
            currentRow.add(generateRow(row - 1).get(i - 1) + generateRow(row - 1).get(i));
        }
        currentRow.add(1);
        return currentRow;
    }
}