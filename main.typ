#import "/config.typ": *
#import "@preview/suiji:0.3.0": *

#show: init
#show strong: alert
#show emph: it => {
  let colors = (
     rgb("#4285F4"),
     rgb("#34A853"),
     rgb("#FBBC05"),
     rgb("#EA4335"),
  )
  
  for i in range(it.body.text.len()){
    let rng = gen-rng(i);
    let index = integers(rng, low: 0, high: 4, size: none, endpoint: false).at(1);
    let color = colors.at(index);
    let char = it.body.text.at(i);
    set text(fill: color)
    [#char]
  }
}

#show: slides

#include "/content.typ"