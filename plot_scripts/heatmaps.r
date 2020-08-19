df <- read.csv("../ExperimentalDesign/full_cpu_np20.csv")
str(df)

library(dplyr)
library(ggplot2)
library(paletteer)

#cf_palette <- "pals::jet"
cf_palette <- "pals::coolwarm"
base_size <- 20

plot_df <- df %>%
    group_by(ksp_type, pc_type) %>%
    mutate(experiment_id = row_number(),
           mean_response = mean(response),
           ci_response = (1.96 * sd(response)) / sqrt(n())) %>%
    ungroup() %>%
    distinct(ksp_type, pc_type, .keep_all = TRUE)

p <- ggplot(plot_df) +
    geom_tile(aes(y = ksp_type,
                  x = pc_type,
                  fill = mean_response,
                  color = mean_response)) +
    geom_text(aes(y = ksp_type,
                  x = pc_type,
                  label = paste(round(mean_response, 2),
                                "+/-",
                                round(ci_response, 1),
                                sep = "")),
              color = "white",
              size = 6) +
    scale_fill_paletteer_c(name = "Duration",
                           cf_palette,
                           guide = guide_colorbar(barwidth = 0.7,
                                                  barheight = 70,
                                                  direction = "vertical",
                                                  label.hjust = 1,
                                                  ticks = FALSE,
                                                  reverse = FALSE),
                           limits = c(min(plot_df$mean_response),
                                      max(plot_df$mean_response))) +
    scale_color_paletteer_c(cf_palette) +
    scale_x_discrete(expand = c(0,0)) +
    scale_y_discrete(expand = c(0,0)) +
    theme_bw(base_size = base_size) +
    theme(legend.position = "right",
          legend.background = element_rect(fill = "transparent", colour = NA),
          legend.text = element_text(size = 16),
          legend.title = element_text(size = 23, margin = margin(r = 10)),
          legend.spacing.x = unit(0.0, 'cm'),
          axis.ticks.y = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(color = FALSE)

p

ggsave("../pictures/cpu_means_heatmap.pdf",
       p,
       "pdf",
       width = 10,
       height = 16)

df <- read.csv("../ExperimentalDesign/full_gpu.csv")
str(df)

library(dplyr)
library(ggplot2)
library(paletteer)

#cf_palette <- "pals::jet"
cf_palette <- "pals::coolwarm"
base_size <- 20

plot_df <- df %>%
    group_by(ksp_type, pc_type) %>%
    mutate(experiment_id = row_number(),
           mean_response = mean(response),
           ci_response = (1.96 * sd(response)) / sqrt(n())) %>%
    ungroup() %>%
    distinct(ksp_type, pc_type, .keep_all = TRUE)

p <- ggplot(plot_df) +
    geom_tile(aes(y = ksp_type,
                  x = pc_type,
                  fill = mean_response,
                  color = mean_response)) +
    geom_text(aes(y = ksp_type,
                  x = pc_type,
                  label = paste(round(mean_response, 2),
                                "+/-",
                                round(ci_response, 1),
                                sep = "")),
              color = "white",
              size = 6) +
    scale_fill_paletteer_c(name = "Duration",
                           cf_palette,
                           guide = guide_colorbar(barwidth = 0.7,
                                                  barheight = 70,
                                                  direction = "vertical",
                                                  label.hjust = 1,
                                                  ticks = FALSE,
                                                  reverse = FALSE),
                           limits = c(min(plot_df$mean_response),
                                      max(plot_df$mean_response))) +
    scale_color_paletteer_c(cf_palette) +
    scale_x_discrete(expand = c(0,0)) +
    scale_y_discrete(expand = c(0,0)) +
    theme_bw(base_size = base_size) +
    theme(legend.position = "right",
          legend.background = element_rect(fill = "transparent", colour = NA),
          legend.text = element_text(size = 16),
          legend.title = element_text(size = 23, margin = margin(r = 10)),
          legend.spacing.x = unit(0.0, 'cm'),
          axis.ticks.y = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    guides(color = FALSE)

p

ggsave("../pictures/gpu_means_heatmap.pdf",
       p,
       "pdf",
       width = 10,
       height = 16)
