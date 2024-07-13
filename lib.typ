#let dark_theme=false

#let (
  theme-primary,
  theme-secondary,
  theme-tertiary,
  theme-error,
  theme-background,
  theme-outline,
) = if dark_theme {
  (
    rgb("#ADC6FF"),
    rgb("#9CD49F"),
    rgb("#EAC16C"),
    rgb("#FFB4A9"),
    rgb("#111318"),
    rgb("#8E9099"),
  )
} else {
  (
    rgb("#445E91"),
    rgb("#36693E"),
    rgb("#785A0B"),
    rgb("#904A41"),
    rgb("#F9F9FF"),
    rgb("#74777F"),
  )
}

#let (
  primary,
  secondary,
  tertiary,
  error,
)=(
  rgb("#4285F4"),
  rgb("#34A853"),
  rgb("#FBBC05"),
  rgb("#EA4335"),
)

#let dye(text)={
  let colors = [
    #theme-primary,
    #theme-secondary,
    #theme-tertiary,
    #theme-error,
  ]
  for i in range(11) {
    let color = colors[i % 4];
    let char = text[i];
    // 用指定的颜色包裹每个字符
    set text(color: color)
    [#char]
  }
}

#let XOR(a, b)={
  (a or b) and not (a and b)
}

#let hash(seed, index)={
    XOR(index*31+seed*17, index*8) and 0x3
}