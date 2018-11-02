

# ggformula 0.9.0

 * `ggformula` now requires `ggplot2 (>= 3.0.0)`.  This should take care of issues in 0.8.0 when `ggplot2` was upgraded *after* upgrading `ggformula`.
 * `pkgdown` website created at https://projectmosaic.github.io/ggformula/
 * Several horizontal versions of geom and stats are implemented using `ggstance`.
 * `vdiffr` is used for testing plot output
 

# ggformula 0.8.0

 * The internals of all of the `gf_` funcitons have been modified to make them
 work with `ggplot2` version 2.3. In future releases, a version `ggplot2` at
 least this new will be required.
 
 * The default value for `se` in `gf_smooth()` has been changed from `TRUE` to `FALSE`.  
 
 * `gf_sf()` added to support simple features data for maps.
 
 * improved documentation and examples
 
# ggformula 0.7.0

 * Formulas of the shape `y ~ .` can be used for plots that require a `y` aesthetic 
   but no `x` aesthetic.
 * Added `gf_rugx()` and `gf_rugy()`.  Also additional examples using rugs are given in
   the documentation.
 * Added `gf_polygon()` for simple maps.  (Improved mapping capabilities should be coming
   when `ggplot2` hits version 2.3.)
 * Some internals have been reworked to improve the processing of arguments and deciding
   when to display the quick help for plotting functions.
 * Modifications to the environments in which some functions are evaluated.

# ggformula 0.6.2

  * Improved scoping of `gf_` functions makes it easier to work with data in the global environment.
  * New functions `gf_props()` and `gf_percents()` added to simplify creating bar graphs on a proportion or percent scale.
  * New arguments `xlab`, `ylab`, `title`, `subtitle`, and `caption` added to `gf_` functions.  In the case of `gf_props()` and `gf_percents()` these are prepopulated with defaults of "proportion" and "percent" to give nicer labeling of the plot.
  * The use of `weatherData` has been removed since that package is no longer on CRAN
  * Improvements to `gf_abline()`, `gf_hline()`, and `gf_vline()` expand the usable portion of the API.
  * Additional examples for some functions.

# ggformula 0.6.1

Minor update primarily to support vignette data sets moving from `StatisticalModeling` to 
`mosaicModel`.

  * Also added `gf_fitdistr()`.

# ggformula 0.6.0

Mostly minor changes:

  * Improved documentation of gf_ functions.
  * na.warn() is now re-exported.
  * Bug fix in gf_violin().
  * Reformatted quick help messages.


# ggformula 0.5.0

For version 0.5, the internals of `ggformula` have been largely redesigned to allow 
implementation of some new features.  The new version relies much less on string parsing.

  * Some important changes to formula parsing include
    * `attribute:value` and `attribute::expression` are no longer supported within the main formula.
    * In exchange, things like `gf_point(1:10 ~ 1:10)` work, making it simpler to create on the fly plots
      without having to build a data frame first.
    * `y ~ 1` is equivalent to `~ y` in functions that allow the `~ y` formula shape.  Example: `gf_histogram(age ~ 1)` and `gf_histogram( ~ age)` are equivalent
    
  * Some new functions have been added
    * `gf_dist()` can plot distributions
    * `gf_dhistogram()` plots density histograms by default
    * `gf_ash()` creates ASH plots
    
  * `df_stats()` has been improved to handle one-sided formulas better.
  
  * Secondary layers are now able to inherit both data and formula-defined attributes from the primary layer.  Use 
  `inherit = FALSE` if you don't want inheritance.  (A few functions have `inherit = FALSE` as their default because
  it seems unlikely that inheriting will be desireable.)
  
  
  
  
# ggformula 0.4.0

Version 0.4.0 constitutes a stable beta release.  Changes to the API are still possible, but more 
likely future changes will focus on expansion of the suite of functions supplied, changes to
the internal implementation, and improved documentation.

  * Separated `ggformula` from `statisticalModeling`.
  * Added support for many more geoms.
  * Improved parsing of formulas.  This is still a bit clunky since the order of operations in
  R formulas does not match what we would prefer in this package.
  * `data` may now be an expression (like `data = KidsFeet %>% filter(sex == "G")`)
  * Added support for geoms that have different required aesthetics.
  * Added support for functions that allow more than one formula shape.  Example: `gf_histogram()`
  accepts formulas with shape ` ~ x` or `y ~ x`.  This makes it possible to create density 
  histograms with `gf_histogram()`.
  * Parntheses now halt parsing of formulas.  This allows for on-the-fly computations in formulas.  Typically these computed expressions must be within parentheses to avoid formula expansion.
  * Use `::` to indicate mapping aesthetics.  (`:` will autodetect, but only if the value
is the name of a variable in the data set.)  This should be considered experimental.
  * Added wrappers `gf_lims()`, `gf_labs()`, `gf_theme()`, `gf_facet_grid()`, `gf_facet_wrap()`
  * Added `gf_refine()` which can be used to pass by chaining anything that would have been "added" in ``ggplot2`
  * Expanded and improved vignette describing use of the package.
  * Added two tutorials.
  * Added "quick help" for plotting functions.
  * Added `gf_lm()`, which is `gf_smooth()` with `method = "lm"`
  * Added `gf_dens()` which is `gf_line()` with `stat = "density"`.



