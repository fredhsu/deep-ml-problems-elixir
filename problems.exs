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
  def cosine_similarity(a,b) do
    norm = &(:math.sqrt(dotproduct(&1,&1)))
    dotproduct(a,b)/(norm.(a)*norm.(b))
  end

  def calculate_matrix_mean(matrix, "row") do
    Enum.map(matrix,fn x->Enum.sum(x)/length(x)end)
  end
  def calculate_matrix_mean(matrix, _) do
    transpose(matrix)
      |>calculate_matrix_mean("row")
  end
  def get_diagonal(matrix) do
    matrix
      |> Enum.with_index()
      |> Enum.map(fn {row, i} -> Enum.at(row, i) end)
  end
  def get_anti_diagonal(matrix) do
    matrix
      |> Enum.with_index()
      |> Enum.map(fn {row, i} -> Enum.at(row, length(row) - 1 - i) end)
  end
  def calculate_eigenvalues(matrix) do
    diag1 = matrix
      |> Enum.with_index()
      |> Enum.map(fn {row, i} -> Enum.at(row, i) end)
    diag2 = matrix
      |> Enum.with_index()
      |> Enum.map(fn {row, i} -> Enum.at(row, length(row) - 1 - i) end)

    IO.inspect diag1
    IO.inspect diag2
    trace = Enum.sum(diag1)
    b = -trace
    det = Enum.product(diag1) - Enum.product(diag2)
    root1 = (-1*b + :math.sqrt(:math.pow(b,2)-4*det)) / 2
    root2 = (-1*b - :math.sqrt(:math.pow(b,2)-4*det)) / 2
    [root1,root2]
  end
  def inverse_2x2(matrix) do
    a = Enum.at(matrix, 0)
      |> Enum.at(0)
    b = Enum.at(matrix, 0)
      |> Enum.at(1)
    c = Enum.at(matrix, 1)
      |> Enum.at(0)
    d = Enum.at(matrix, 1)
      |> Enum.at(1)
    det = a*d - b*c
    [
      Enum.map([d,-b],&(&1 * 1/det)),
      Enum.map([-c,a],&(&1 * 1/det))
    ]
  end

  def test() do
    vec1 = [1,2,3]
    vec2 = [4,5,6]
    vec3 = [1,2]
    vec4 = [1, 0, 7]
    vec5 = [0, 1, 3]
    matrix1 = [[1,2],[2,4]]
    matrix2 = [vec1,vec2]
    matrix3 = [[0,-1],[1,0]]
    matrix4 = [[2,1],[1,2]]
    matrix5 = [[4,-2],[1,1]]

    assert dotproduct(vec1, vec2)==32
    IO.inspect(matrix_vector_dot_product(matrix1, vec3))
    IO.inspect(transpose(matrix2))
    assert scalar_multiply(matrix1, 2)==[[2, 4], [4, 8]]
    assert scalar_multiply(matrix3, -1)==[[0, 1], [-1, 0]]
    assert Float.round(cosine_similarity(vec4, vec5),3) == 0.939

    assert calculate_matrix_mean(matrix2, "row") == [2.0,5.0]
    assert calculate_matrix_mean([[1, 2, 3, 4], [5, 6, 7, 8]], "column") == [3.0,4.0,5.0,6.0]

    assert calculate_eigenvalues(matrix4) == [3.0,1.0]
    assert calculate_eigenvalues(matrix5) == [3.0,2.0]

    assert inverse_2x2([[2,1],[6,2]]) == [[-1,0.5],[3.0,-1.0]]
  end

end

