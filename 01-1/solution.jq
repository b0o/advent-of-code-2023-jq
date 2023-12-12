.
| map(
   .
   | split("")
   | map(tonumber?)
   | "\(.[0])\(.[-1])"
   | tonumber
  )
| add
