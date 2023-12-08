.
| split("\n")
| map(
   .
   | select(length > 0)
   | split("")
   | map(tonumber?)
   | "\(.[0])\(.[-1])"
   | tonumber
  )
| add
