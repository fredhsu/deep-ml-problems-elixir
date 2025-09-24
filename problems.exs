defmodule DeepML do
  use ExUnit.Case
  def scalar_multiply(matrix, scalar) do
    Enum.map(matrix, fn x -> Enum.map(x, 
      fn y -> y*scalar end)
    end)
  end
  def transpose(a) do
    Enum.map(Enum.zip(a), fn x -> Tuple.to_list(x) end)
  end
  def dotproduct(vec1, vec2) do
    Enum.zip(vec1, vec2)
      |> Enum.map(fn {x,y} -> x*y end)
      |> Enum.sum()
  end

  def matrix_vector_dot_product(a,b) when length(a) != length(b), do: -1
  def matrix_vector_dot_product(a,b) do
      Enum.map(a, fn row -> dotproduct(row, b) end)
  end

  def test() do
    vec1 = [1,2,3]
    vec2 = [4,5,6]
    vec3 = [1,2]
    matrix1 = [[1,2],[2,4]]
    matrix2 = [vec1,vec2]
    matrix3 = [[0,-1],[1,0]]

    assert dotproduct(vec1, vec2)==32
    IO.inspect(matrix_vector_dot_product(matrix1, vec3))
    IO.inspect(transpose(matrix2))
    assert scalar_multiply(matrix1, 2)==[[2, 4], [4, 8]]
    assert scalar_multiply(matrix3, -1)==[[0, 1], [-1, 0]]
  end

end

