
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SAI

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Save time and effort by using SAI to clean and standardise your data.
The SAI package is your AI assistant that contain a collection of
functions to help you with your data cleaning tasks.

## Installation

You can install the development version of SAI like so:

``` r
# install.packages("pak")
pak::pak("emitanaka/SAI")
```

You will also need to install Ollama and one of the models, such as
llama3.1:8b (the default for the SAI package). You can do this by
running the following command in your terminal:

``` bash
ollama pull llama3.1:8b
```

## Example

``` r
library(SAI)
```

### Correcting order of levels for ordinal variables

The levels of categorical variables by default are ordered
alphabetically. This can be problematic when the levels have a natural
order.

``` r
factor(likerts$likert1)
#>  [1] Strongly Disagree Neutral           Strongly Agree    Strongly Disagree
#>  [5] Disagree          Somewhat Agree    Strongly Agree    Somewhat Disagree
#>  [9] Agree             Disagree          Somewhat Disagree Somewhat Disagree
#> [13] Strongly Disagree Somewhat Agree    Somewhat Agree    Disagree         
#> [17] Agree             Agree             Disagree          Strongly Agree   
#> [21] Strongly Disagree Strongly Agree    Somewhat Agree    Somewhat Agree   
#> [25] Strongly Disagree Strongly Disagree Agree             Somewhat Agree   
#> [29] Somewhat Agree    Disagree          Disagree          Agree            
#> [33] Strongly Disagree Neutral           Strongly Agree    Strongly Disagree
#> [37] Neutral           Somewhat Disagree Agree             Disagree         
#> 7 Levels: Agree Disagree Neutral Somewhat Agree ... Strongly Disagree
```

A correct order may need to be manually specified like below, but it can
be a tedious task.

``` r
factor(likerts$likert1, 
       levels = c("Strongly Disagree", "Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Agree", "Strongly Agree")) 
#>  [1] Strongly Disagree Neutral           Strongly Agree    Strongly Disagree
#>  [5] Disagree          Somewhat Agree    Strongly Agree    Somewhat Disagree
#>  [9] Agree             Disagree          Somewhat Disagree Somewhat Disagree
#> [13] Strongly Disagree Somewhat Agree    Somewhat Agree    Disagree         
#> [17] Agree             Agree             Disagree          Strongly Agree   
#> [21] Strongly Disagree Strongly Agree    Somewhat Agree    Somewhat Agree   
#> [25] Strongly Disagree Strongly Disagree Agree             Somewhat Agree   
#> [29] Somewhat Agree    Disagree          Disagree          Agree            
#> [33] Strongly Disagree Neutral           Strongly Agree    Strongly Disagree
#> [37] Neutral           Somewhat Disagree Agree             Disagree         
#> 7 Levels: Strongly Disagree Disagree Somewhat Disagree ... Strongly Agree
```

The `sai_fct_reorder()` function will try to reorder the levels of the
factor in a meaningful way *automatically* using a large language model.

``` r
sai_fct_reorder(likerts$likert1) |> levels()
#> [1] "Strongly Disagree" "Disagree"          "Somewhat Disagree"
#> [4] "Neutral"           "Somewhat Agree"    "Agree"            
#> [7] "Strongly Agree"
```

### Large language model

The default large language model is shown below.

``` r
sai_get_option("model")
#> [1] "llama3.1:8b"
```

You can change the model to another one (provided that it is available
in your system) like so:

``` r
sai_set_option("model", "llama3.1:1b")
```

Tiny models (1b) are faster but less accurate. It is not recommended to
use them for important tasks.

### Categorise text

Some categorical variables can have simple typos or alternative
representations. For example below we have UK written also as “United
Kingdom”.

``` r
messy$country
#>  [1] "UK"             "US"             "Canada"         "UK"            
#>  [5] "US"             "Canada"         "United Kingdom" "USA"           
#>  [9] "New Zealand"    "NZ"             "Australia"      "New Zealand"   
#> [13] "UK"             "United Kingdom" "UK"             "US"            
#> [17] "United Kingdom" "Australia"      "US"             "Australia"
```

While you can manually fix this, again, this can be tedious. We can map
this automatically using `sai_fct_match()`

``` r
sai_fct_match(messy$country, levels = c("UK", "USA", "Canada", "Australia", "NZ"))
#>  [1] UK        USA       Canada    UK        USA       Canada    UK       
#>  [8] USA       NZ        NZ        Australia NZ        UK        UK       
#> [15] UK        USA       UK        Australia USA       Australia
#> Levels: UK USA Canada Australia NZ
```

The function actucally works to match a continent as well! Let’s use
`sai_lvl_match()` to more easily see the conversion on the levels alone.

``` r
sai_lvl_match(messy$country, levels = c("Asia", "Europe", "North America", "Oceania", "South America"))
#>              UK              US          Canada  United Kingdom             USA 
#>        "Europe" "North America" "North America"        "Europe" "North America" 
#>     New Zealand              NZ       Australia 
#>       "Oceania"       "Oceania"       "Oceania"
#> 
#> ── Converted by SAI: ───────────────────────────────────────────────────────────
#>         original     converted
#> 1             UK        Europe
#> 2 United Kingdom        Europe
#> 3             US North America
#> 4         Canada North America
#> 5            USA North America
#> 6    New Zealand       Oceania
#> 7             NZ       Oceania
#> 8      Australia       Oceania
```

### Translate

The `sai_translate()` function can be used to translate text to another
language (default English).

``` r
sai_translate(c("猿も木から落ちる", "你好"))
#> [1] "Even monkeys fall from trees.\n\n(This is a Japanese proverb, often translated as \"even the cleverest people can make mistakes\".)"
#> [2] "Hello \n\nTranslated to English, it becomes:\n\nHello"
```
