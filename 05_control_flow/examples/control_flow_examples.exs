# Control Flow Examples

# Run with: elixir control_flow_examples.exs

IO.puts("=== CONTROL FLOW EXAMPLES ===")

# if/else examples
IO.puts("\n--- if/else ---")

defmodule AgeChecker do
  def check_voting_age(age) do
    if age >= 18 do
      "You can vote!"
    else
      "You can vote in #{18 - age} years."
    end
  end
  
  def check_drinking_age(age) do
    message = if age >= 21, do: "You can drink alcohol", else: "No alcohol yet"
    message
  end
end

IO.puts(AgeChecker.check_voting_age(20))
IO.puts(AgeChecker.check_voting_age(16))
IO.puts(AgeChecker.check_drinking_age(25))

# unless example
IO.puts("\n--- unless ---")

defmodule AccessControl do
  def check_access(user_role) do
    unless user_role == :guest do
      "Access granted"
    else
      "Please log in"
    end
  end
end

IO.puts(AccessControl.check_access(:admin))
IO.puts(AccessControl.check_access(:guest))

# case examples
IO.puts("\n--- case ---")

defmodule ResponseHandler do
  def handle_response(response) do
    case response do
      {:ok, data} when is_binary(data) ->
        "Received string data: #{data}"
      
      {:ok, data} when is_list(data) ->
        "Received list with #{length(data)} items"
      
      {:ok, %{} = data} ->
        "Received map data: #{inspect(data)}"
      
      {:error, :timeout} ->
        "Request timed out"
      
      {:error, :network} ->
        "Network error occurred"
      
      {:error, reason} ->
        "Error: #{reason}"
      
      _ ->
        "Unknown response format"
    end
  end
end

# Test different response types
IO.puts(ResponseHandler.handle_response({:ok, "Hello World"}))
IO.puts(ResponseHandler.handle_response({:ok, [1, 2, 3]}))
IO.puts(ResponseHandler.handle_response({:ok, %{user: "Alice"}}))
IO.puts(ResponseHandler.handle_response({:error, :timeout}))
IO.puts(ResponseHandler.handle_response({:error, "Custom error"}))
IO.puts(ResponseHandler.handle_response(:unknown))

# cond examples
IO.puts("\n--- cond ---")

defmodule GradeCalculator do
  def letter_grade(percentage) do
    cond do
      percentage >= 97 -> "A+"
      percentage >= 93 -> "A"
      percentage >= 90 -> "A-"
      percentage >= 87 -> "B+"
      percentage >= 83 -> "B"
      percentage >= 80 -> "B-"
      percentage >= 77 -> "C+"
      percentage >= 73 -> "C"
      percentage >= 70 -> "C-"
      percentage >= 67 -> "D+"
      percentage >= 65 -> "D"
      true -> "F"
    end
  end
  
  def performance_feedback(grade) do
    cond do
      grade in ["A+", "A", "A-"] -> "Excellent work!"
      grade in ["B+", "B", "B-"] -> "Good job!"
      grade in ["C+", "C", "C-"] -> "Satisfactory"
      grade in ["D+", "D"] -> "Needs improvement"
      true -> "Please see instructor"
    end
  end
end

test_scores = [98, 85, 72, 88, 61]
Enum.each(test_scores, fn score ->
  grade = GradeCalculator.letter_grade(score)
  feedback = GradeCalculator.performance_feedback(grade)
  IO.puts("Score #{score}% = Grade #{grade}: #{feedback}")
end)

# with examples
IO.puts("\n--- with ---")

defmodule OrderProcessor do
  def process_order(order_data) do
    with {:ok, item} <- validate_item(order_data["item"]),
         {:ok, quantity} <- validate_quantity(order_data["quantity"]),
         {:ok, payment} <- validate_payment(order_data["payment"]),
         {:ok, total} <- calculate_total(item, quantity),
         {:ok, _receipt} <- process_payment(payment, total) do
      {:ok, "Order processed successfully for #{quantity} #{item}(s)"}
    else
      {:error, :invalid_item} -> {:error, "Invalid item selected"}
      {:error, :invalid_quantity} -> {:error, "Quantity must be positive"}
      {:error, :insufficient_funds} -> {:error, "Insufficient funds"}
      {:error, reason} -> {:error, "Processing failed: #{reason}"}
    end
  end
  
  defp validate_item(item) when is_binary(item) and byte_size(item) > 0, do: {:ok, item}
  defp validate_item(_), do: {:error, :invalid_item}
  
  defp validate_quantity(qty) when is_integer(qty) and qty > 0, do: {:ok, qty}
  defp validate_quantity(_), do: {:error, :invalid_quantity}
  
  defp validate_payment(%{"type" => "credit", "amount" => amount}) when amount > 0 do
    {:ok, %{type: :credit, amount: amount}}
  end
  defp validate_payment(_), do: {:error, :invalid_payment}
  
  defp calculate_total(item, quantity) do
    # Simple pricing
    price_map = %{"apple" => 1.50, "banana" => 0.75, "orange" => 2.00}
    case Map.get(price_map, item) do
      nil -> {:error, :item_not_found}
      price -> {:ok, price * quantity}
    end
  end
  
  defp process_payment(%{amount: available}, total) when available >= total do
    {:ok, %{receipt_id: :rand.uniform(10000), amount_charged: total}}
  end
  defp process_payment(_, _), do: {:error, :insufficient_funds}
end

# Test order processing
valid_order = %{
  "item" => "apple",
  "quantity" => 3,
  "payment" => %{"type" => "credit", "amount" => 10.00}
}

invalid_order = %{
  "item" => "",
  "quantity" => -1,
  "payment" => %{"type" => "cash"}
}

IO.puts("Valid order: #{inspect(OrderProcessor.process_order(valid_order))}")
IO.puts("Invalid order: #{inspect(OrderProcessor.process_order(invalid_order))}")

# Guard examples in control flow
IO.puts("\n--- Guards in Control Flow ---")

defmodule NumberAnalyzer do
  def analyze(n) when is_number(n) do
    cond do
      n == 0 -> "Zero"
      n > 0 and is_integer(n) and rem(n, 2) == 0 -> "Positive even integer"
      n > 0 and is_integer(n) -> "Positive odd integer"
      n > 0 -> "Positive float"
      n < 0 and is_integer(n) -> "Negative integer"
      n < 0 -> "Negative float"
    end
  end
  
  def analyze(_), do: "Not a number"
end

test_numbers = [0, 4, 7, -3, 3.14, -2.5, "not a number"]
Enum.each(test_numbers, fn num ->
  IO.puts("#{inspect(num)}: #{NumberAnalyzer.analyze(num)}")
end)

IO.puts("\n=== END OF CONTROL FLOW EXAMPLES ===")
