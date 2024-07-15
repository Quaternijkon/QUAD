#import "@preview/touying:0.4.2": *

// University theme

// Originally contributed by Pol Dellaiera - https://github.com/drupol

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

// #let colors = [
//   #theme-primary,
//   #theme-secondary,
//   #theme-tertiary,
//   #theme-error,
// ]

// #let color_text(text,colors)={
//   for i in range(0, 11) {
//     let color = colors[i % 4];
//     let char = text[i];
//     // 用指定的颜色包裹每个字符
//     set text(color: color)
//     [#char]
//   }
// }

// #let dye(text)={
//   let colors = [
//     #theme-primary,
//     #theme-secondary,
//     #theme-tertiary,
//     #theme-error,
//   ]
//   for i in range(0, text.length()) {
//     let color = colors[i % 4];
//     let char = text[i];
//     // 用指定的颜色包裹每个字符
//     set text(color: color)
//     [#char]
//   }

// }



#let slide(
  self: none,
  title: auto,
  subtitle: auto,
  header: auto,
  footer: auto,
  display-current-section: auto,
  ..args,
) = {
  if title != auto {
    self.quad-title = title
  }
  if subtitle != auto {
    self.quad-subtitle = subtitle
  }
  if header != auto {
    self.quad-header = header
  }
  if footer != auto {
    self.quad-footer = footer
  }
  if display-current-section != auto {
    self.quad-display-current-section = display-current-section
  }
  (self.methods.touying-slide)(
    ..args.named(),
    self: self,
    setting: body => {
      show: args.named().at("setting", default: body => body)
      body
    },
    ..args.pos(),
  )
}

#let title-slide(self: none, ..args) = {//首页
  self = utils.empty-page(self)
  let info = self.info + args.named()
  info.authors = {
    let authors =  if "authors" in info { info.authors } else { info.author }
    if type(authors) == array { authors } else { (authors,) }
  }
  let content = {
    if info.logo != none {
      align(right, info.logo)
    }
    align(center + horizon, {
      block(
        fill: self.colors.primary,
        inset: 1.5em,
        radius: 0.5em,
        breakable: false,
        {
          text(size: 1.22em, fill: white, weight: "bold", info.title)
          if info.subtitle != none {
            parbreak()
            text(size: 1.0em, fill: white, weight: "bold", info.subtitle)
          }
        }
      )
      // set text(size: .8em)
      grid(
        columns: (1fr,) * calc.min(info.authors.len(), 3),
        column-gutter: 1em,
        row-gutter: 1em,
        ..info.authors.map(author => text( author ))
      )
      v(0.5em)
      if info.institution != none {
        parbreak()
        text(size: .7em,  info.institution)
      }
      if info.date != none {
        parbreak()
        text(size: 1.0em,  utils.info-date(self))
      }
    })
  }
  (self.methods.touying-slide)(self: self, repeat: none, content)
}

#let quad-outline(self: none) = states.touying-progress-with-sections(dict => {
  let (current-sections, final-sections) = dict
  current-sections = current-sections.filter(section => section.loc != none).map(section => (
    section,
    section.children,
  )).flatten().filter(item => item.kind == "section")
  final-sections = final-sections.filter(section => section.loc != none).map(section => (
    section,
    section.children,
  )).flatten().filter(item => item.kind == "section")
  let current-index = current-sections.len() - 1

  for (i, section) in final-sections.enumerate() {
    if i == 0 {
      continue
    }
    set text(fill: if current-index == 0 or i == current-index {
      self.colors.primary
    } else {
      self.colors.primary.lighten(80%)
    })
    block(
      spacing: 1.5em,
      [#link(section.loc, utils.section-short-title(section))<touying-link>],
    )
  }
})

#let outline-slide(self: none) = {
  // Generates an outline slide with a title and content.
  // The title is displayed as "目录" if the text language is "zh", otherwise it is displayed as "Outline".
  // The content includes alignment settings, bold text, and the buaa-outline function.
  // The outline slide is created using the touying-slide method.
  // Parameters:
  // - self: The self parameter of the outline-slide function.
  // Returns:
  // - The generated outline slide.
  self.quad-title = context if text.lang == "zh" [目录] else [目录]
  let content = {
    set align(horizon)
    set text(weight: "bold")
    hide([-])
    quad-outline(self: self)
  }
  (self.methods.touying-slide)(self: self, repeat: none, section: (title: context if text.lang == "zh" [目录] else [目录]), content)
}

#let new-section-slide(self: none, short-title: auto, title) = {
  self = utils.empty-page(self)
  let content(self) = {
    set align(horizon)
    show: pad.with(20%)
    set text(size: 1.5em, fill: self.colors.primary, weight: "bold")
    states.current-section-with-numbering(self)
    v(-.5em)
    block(height: 2pt, width: 100%, spacing: 0pt, utils.call-or-display(self, self.quad-progress-bar))
  }
  (self.methods.touying-slide)(self: self, repeat: none, section: (title: title, short-title: short-title), content)
}

#let focus-slide(self: none, background-color: none, background-img: none, body) = {
  let background-color = if background-img == none and background-color ==  none {
    rgb(self.colors.primary)
  } else {
    background-color
  }
  self = utils.empty-page(self)
  self.page-args += (
    fill: self.colors.primary-dark,
    margin: 1em,
    ..(if background-color != none { (fill: background-color) }),
    ..(if background-img != none { (background: {
        set image(fit: "stretch", width: 100%, height: 100%)
        background-img
      })
    }),
  )
  set text(fill: white, weight: "bold", size: 2em)
  (self.methods.touying-slide)(self: self, repeat: none, align(horizon, body))
}

#let matrix-slide(self: none, columns: none, rows: none, ..bodies) = {
  self = utils.empty-page(self)
  (self.methods.touying-slide)(self: self, composer: (..bodies) => {
    let bodies = bodies.pos()
    let columns = if type(columns) == int {
      (1fr,) * columns
    } else if columns == none {
      (1fr,) * bodies.len()
    } else {
      columns
    }
    let num-cols = columns.len()
    let rows = if type(rows) == int {
      (1fr,) * rows
    } else if rows == none {
      let quotient = calc.quo(bodies.len(), num-cols)
      let correction = if calc.rem(bodies.len(), num-cols) == 0 { 0 } else { 1 }
      (1fr,) * (quotient + correction)
    } else {
      rows
    }
    let num-rows = rows.len()
    if num-rows * num-cols < bodies.len() {
      panic("number of rows (" + str(num-rows) + ") * number of columns (" + str(num-cols) + ") must at least be number of content arguments (" + str(bodies.len()) + ")")
    }
    let cart-idx(i) = (calc.quo(i, num-cols), calc.rem(i, num-cols))
    let color-body(idx-body) = {
      let (idx, body) = idx-body
      let (row, col) = cart-idx(idx)
      let color = if calc.even(row + col) { white } else { silver }
      set align(center + horizon)
      rect(inset: .5em, width: 100%, height: 100%, fill: color, body)
    }
    let content = grid(
      columns: columns, rows: rows,
      gutter: 0pt,
      ..bodies.enumerate().map(color-body)
    )
    content
  }, ..bodies)
}

#let slides(self: none, title-slide: true, slide-level: 1, ..args) = {
  if title-slide {
    (self.methods.title-slide)(self: self)
  }
  (self.methods.touying-slides)(self: self, slide-level: slide-level, ..args)
}

#let register(
  self: themes.default.register(),
  aspect-ratio: "16-9",
  progress-bar: true,
  display-current-section: true,
  footer-columns: (10%,75%,10%,5%),
  footer-a: self => self.info.author,
  footer-b: self => if self.info.short-title == auto { self.info.title } else { self.info.short-title },
  footer-c: self => {
    h(1fr)
    utils.info-date(self)
    h(1fr)
    // states.slide-counter.display() + " / " + states.last-slide-number
    // h(1fr)
  },
  footer-d: self => {
    h(1fr)
    states.slide-counter.display() + " / " + states.last-slide-number
    h(1fr)
  },
) = {
  // color theme
  self = (self.methods.colors)(
    self: self,
    primary: rgb("#4285F4"),
    secondary: rgb("#34A853"),
    tertiary: rgb("#FBBC05"),
    error: rgb("#EA4335"),

    // primary: rgb("#445E91"),
    // secondary: rgb("#36693E"),
    // tertiary: rgb("#785A0B"),
    // error: rgb("#904A41"),
    // background: rgb("#F9F9FF"),
    // outline: rgb("#74777F"),

    // primary: rgb("#ADC6FF"),
    // secondary: rgb("#9CD49F"),
    // tertiary: rgb("#EAC16C"),
    // error: rgb("#FFB4A9"),
    // background: rgb("#111318"),
    // outline: rgb("#8E9099"),

    // (
    //   theme-primary,
    //   theme-secondary,
    //   theme-tertiary,
    //   theme-error,
    //   theme-background,
    //   theme-outline,
    // )=if(dark_theme){
    //   (
    //     rgb("#ADC6FF"),
    //     rgb("#9CD49F"),
    //     rgb("#EAC16C"),
    //     rgb("#FFB4A9"),
    //     rgb("#111318"),
    //     rgb("#8E9099"),
    //   )
    // }else{
    //   (
    //     rgb("#445E91"),
    //     rgb("#36693E"),
    //     rgb("#785A0B"),
    //     rgb("#904A41"),
    //     rgb("#F9F9FF"),
    //     rgb("#74777F"),
    //   )
    // }

    light-primary: rgb("#445E91"),
    light-secondary: rgb("#36693E"),
    light-tertiary: rgb("#785A0B"),
    light-error: rgb("#904A41"),
    light-background: rgb("#F9F9FF"),
    light-outline: rgb("#74777F"),

    dark-primary: rgb("#ADC6FF"),
    dark-secondary: rgb("#9CD49F"),
    dark-tertiary: rgb("#EAC16C"),
    dark-error: rgb("#FFB4A9"),
    dark-background: rgb("#111318"),
    dark-outline: rgb("#8E9099"),
  )
  // save the variables for later use
  self.quad-enable-progress-bar = progress-bar
  self.quad-progress-bar = self => states.touying-progress(ratio => {
    grid(
      columns: (ratio * 100%, 1fr),
      rows: 2pt,
      components.cell(fill: self.colors.secondary),
      components.cell(fill: self.colors.tertiary)
    )
  })
  self.quad-display-current-section = display-current-section
  self.quad-title = none
  self.quad-subtitle = none
  self.quad-footer = self => {
    let cell(fill: none, it) = rect(
      width: 100%, height: 100%, inset: 1mm, outset: 0mm, fill: fill, stroke: none,
      align(horizon, text(fill: white, it))
    )
    show: block.with(width: 100%, height: auto, fill: self.colors.secondary)
    grid(
      columns: footer-columns,
      rows: (1.5em, auto),
      cell(fill: self.colors.primary, utils.call-or-display(self, footer-a)),
      cell(fill: self.colors.secondary, utils.call-or-display(self, footer-b)),
      cell(fill: self.colors.tertiary, utils.call-or-display(self, footer-c)),
      cell(fill: self.colors.error, utils.call-or-display(self, footer-d)),
    )
  }
  self.quad-header = self => {
    if self.quad-title != none {
      block(inset: (x: .5em), 
        grid(
          columns: 1,
          gutter: .3em,
          grid(
            columns: (auto, 1fr, auto),
            align(top + left, text(fill: self.colors.primary, weight: "bold", size: 1.2em, self.quad-title)),
            [],
            if self.quad-display-current-section {
              align(top + right, text(fill: self.colors.primary.lighten(65%), states.current-section-with-numbering(self)))
            }
          ),
          text(fill: self.colors.primary.lighten(65%), size: .8em, self.quad-subtitle)
        )
      )
    }
  }
  // set page
  let header(self) = {
    set align(top)
    grid(
      rows: (auto, auto),
      row-gutter: 3mm,
      if self.quad-enable-progress-bar {
        utils.call-or-display(self, self.quad-progress-bar)
      },
      utils.call-or-display(self, self.quad-header),
    )
  }
  let footer(self) = {
    set text(size: .4em)
    set align(center + bottom)
    utils.call-or-display(self, self.quad-footer)
  }

  self.page-args += (
    paper: "presentation-" + aspect-ratio,
    header: header,
    footer: footer,
    header-ascent: 0em,
    footer-descent: 0em,
    margin: (top: 2.5em, bottom: 1.25em, x: 2em),
  )
  // register methods
  self.methods.slide = slide
  self.methods.title-slide = title-slide
  self.methods.outline-slide = outline-slide
  self.methods.new-section-slide = new-section-slide
  self.methods.touying-new-section-slide = new-section-slide
  self.methods.focus-slide = focus-slide
  self.methods.matrix-slide = matrix-slide
  self.methods.slides = slides
  self.methods.touying-outline = (self: none, enum-args: (:), ..args) => {
    states.touying-outline(self: self, enum-args: (tight: false,) + enum-args, ..args)
  }
  self.methods.alert = (self: none, it) => text(fill: self.colors.primary, it)
  self.methods.init = (self: none, body) => {
    set text(size: 20pt, font: "PingFang SC")
    //TODO:目录从0开始编号
    show footnote.entry: set text(size: .6em)
    body
  }
  self
}