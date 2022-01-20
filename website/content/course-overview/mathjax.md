+++
title = "Math Equations"
description = ""
weight = 41
+++

<script type="text/javascript" async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

*NOTE: We are aware that Daum Equation Editor has not been updated a long while and may no longer be supported on may platforms. We have not yet found a replacement as good as Daum, however have a look at this [Wikipedia page on formula editors](https://en.wikipedia.org/wiki/Formula_editor) for a comprehnsive list of available software.*

Occasionally you will need to type equations in homework and labs. R Markdown supports LaTeX style equations using the [MathJax](https://www.mathjax.org/) javascript library. We do not expect you to learn LaTeX for this course. Instead, we recommend using the free application [Daum Equation Editor](). It is availabe [online](https://www.mathjax.org/), as a [Google Chrome Extension](https://chrome.google.com/webstore/detail/daum-equation-editor/dinfmiceliiomokeofbocegmacmagjhe?hl=en), or as a standalone [Mac Application](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=3&cad=rja&uact=8&ved=0CC4QFjACahUKEwiegvqQod3GAhUCmYAKHctnA5M&url=https%3A%2F%2Fitunes.apple.com%2Fus%2Fapp%2Fdaum-equation-editor%2Fid540665783%3Fmt%3D12&ei=WGKmVZ72DIKyggTLz42YCQ&usg=AFQjCNH69beGYAfr5ojnPILLNOG-goN9sw&sig2=Qw7QV80X8gZjrNyY9PkMHA). 

## Creating Equations with Daum Equation Editor

Occasionally you will need to type equations in homework and labs. R Markdown supports LaTeX style equations using the [MathJax](https://www.mathjax.org/) javascript library. We do not expect you to learn LaTeX for this course. Instead, we recommend using the free application [Daum Equation Editor](). It availabe [online](https://www.mathjax.org/), as a [Google Chrome Extension](https://chrome.google.com/webstore/detail/daum-equation-editor/dinfmiceliiomokeofbocegmacmagjhe?hl=en). With the editor, you can enter equations using menus. 

![Daum Equation Editor Screenshot](/images/DaumScreen.png)

Once done, copy and paste the LaTeX code at the bottom into your R Markdown file between two dollar signs (i.e. $), and the quation will be rendered by the web browser.

$$ f\left( x|\mu ,\sigma  \right) =\frac { 1 }{ \sigma \sqrt { 2\pi  }  } { e }^{ -\frac { { \left( x-\mu  \right)  }^{ 2 } }{ { 2\sigma  }^{ 2 } }  } $$


