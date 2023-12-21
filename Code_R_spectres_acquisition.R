#Goal : Visualisation and second pre-treatment of the spectral dataset
#Authors : Cing Lee, Romeo Roux-Vaneph, Adele Hardy and Aubin Patouillard

## PATHS IMPORTATION
# Specify the path to the main folder
main_folder <- "C:/Users/Utilisateur/Snails_Project/Temoins"
# Get the list of subfolders in the main folder
subfolders <- list.dirs(main_folder, full.names = TRUE)
# Remove the first element from the subfolders list (which is the main folder itself)
subfolders <- tail(subfolders, -1)

##INITIALISATION
# Initialize a list to store the data
data_list <- list()
# Initialize a list to store files with reflectance > 0.15 at 1000nm
data_list_samples_only <- list()
data_subfolder <- list()
# Wavelengths studied
wavelengths <- c(411.360017, 414.066120, 416.772223, 419.478326, 422.184429, 424.890531, 427.596634, 430.302737, 433.008840, 435.714943, 438.421046, 441.127149, 443.833252, 446.539355, 449.245458, 451.951561, 454.657664, 457.363767, 460.069870, 462.775973, 465.482076, 468.188179, 470.894281, 473.600384, 476.306487, 479.012590, 481.718693, 484.424796, 487.130899, 489.837002, 492.543105, 495.249208, 497.955311, 500.661414, 503.367517, 506.073620, 508.779723, 511.485826, 514.191929, 516.898031, 519.604134, 522.310237, 525.016340, 527.722443, 530.428546, 533.134649, 535.840752, 538.546855, 541.252958, 543.959061, 546.665164, 549.371267, 552.077370, 554.783473, 557.489576, 560.195679, 562.901782, 565.607884, 568.313987, 571.020090, 573.726193, 576.432296, 579.138399, 581.844502, 584.550605, 587.256708, 589.962811, 592.668914, 595.375017, 598.081120, 600.787223, 603.493326, 606.199429, 608.905532, 611.611634, 614.317737, 617.023840, 619.729943, 622.436046, 625.142149, 627.848252, 630.554355, 633.260458, 635.966561, 638.672664, 641.378767, 644.084870, 646.790973, 649.497076, 652.203179, 654.909282, 657.615384, 660.321487, 663.027590, 665.733693, 668.439796, 671.145899, 673.852002, 676.558105, 679.264208, 681.970311, 684.676414, 687.382517, 690.088620, 692.794723, 695.500826, 698.206929, 700.913032, 703.619134, 706.325237, 709.031340, 711.737443, 714.443546, 717.149649, 719.855752, 722.561855, 725.267958, 727.974061, 730.680164, 733.386267, 736.092370, 738.798473, 741.504576, 744.210679, 746.916782, 749.622884, 752.328987, 755.035090, 757.741193, 760.447296, 763.153399, 765.859502, 768.565605, 771.271708, 773.977811, 776.683914, 779.390017, 782.096120, 784.802223, 787.508326, 790.214429, 792.920532, 795.626634, 798.332737, 801.038840, 803.744943, 806.451046, 809.157149, 811.863252, 814.569355, 817.275458, 819.981561, 822.687664, 825.393767, 828.099870, 830.805973, 833.512076, 836.218179, 838.924282, 841.630384, 844.336487, 847.042590, 849.748693, 852.454796, 855.160899, 857.867002, 860.573105, 863.279208, 865.985311, 868.691414, 871.397517, 874.103620, 876.809723, 879.515826, 882.221929, 884.928032, 887.634134, 890.340237, 893.046340, 895.752443, 898.458546, 901.164649, 903.870752, 906.576855, 909.282958, 911.989061, 914.695164, 917.401267, 920.107370, 922.813473, 925.519576, 928.225679, 930.931782, 933.637885, 936.343987, 939.050090, 941.756193, 944.462296, 947.168399, 949.874502, 952.580605, 955.286708, 957.992811, 960.698914, 963.405017, 966.111120, 968.817223, 971.523326, 974.229429, 976.935532, 979.641635, 982.347737, 985.053840, 987.759943, 990.466046, 993.172149)
# Initialize a list to store colors
colors <- rainbow(length(subfolders))

# Initialize a list to store the names of subfolders
subfolder_names <- c()

# Initialisation des colonnes de la matrice classes
num_class_column <- c()
dead_diet_column <- c()
living_diet_column <- c()
size_column <- c()

#ACQUISITION, PRE-TREATMENT AND PRE-VISUALISATION
# Loop through the subfolders
n=1
for (i in seq_along(subfolders)) {
  # List all files in the subfolder
  files <- list.files(subfolders[i])
  # List containing the names of samples (files) for legends
  file_name <-c()
  
  # Filter to only take files with the .csv extension
  csv_files <- files[grep("\\.csv$", files, ignore.case = TRUE)]
  
  # Loop through the CSV files in the subfolder
  for (file in csv_files) {
    # Build the full path
    file_path <- file.path(subfolders[i], file)
    
    # Read data from the CSV file
    data <- read.csv(file_path)
    
    # Add data to the raw list
    data_list[[file]] <- data
    
    # Now filter data to only have sample spectra
    reflectance_987nm <- data[214, "Reflectance"]
    
    # Check if reflectance at 1000nm is greater than 0.15
    if (reflectance_987nm > 0.125) {
      # Add the file to the list of files with reflectance > 0.15 at 1000nm
      data_list_samples_only[[file]] <- data
      data_subfolder[[file]]<- data
    }
    else {
      data_list_samples_only[[file]] <- NA
      data_subfolder[[file]]<- NA
    }
      
      
    # Add the short name of the file to the list (first five characters)
    file_name <- c(file_name, substr(basename(file), 1, 5))
    # Add the short name of the subfolder to the list
    subfolder_names[i] <- substr(basename(subfolders[i]), nchar(basename(subfolders[i])) - 2, nchar(basename(subfolders[i])))
      
    # Add a "num_class" and size column based on the file name
    num_class <- ifelse(grepl("D", basename(file)), 1, ifelse(grepl("L", basename(file)), 2, NA))
    num_class_column <- c(num_class_column, num_class)
    #check the value of the second symbol in the file name to classify them in one of the three size group
    size <- ifelse(substr(basename(file), 2, 2)=="1", 1, ifelse(substr(basename(file), 2, 2)=="2", 2,ifelse(substr(basename(file), 2, 2)=="3",3, NA)))
    print(size)
    size_column <- c(size_column,size)
                   
    # Add "Dead Diet" and "Living Diet" columns
    dead_diet <- ifelse(grepl("D", basename(file)), 1, 0)
    living_diet <- ifelse(grepl("L", basename(file)), 1, 0)
    dead_diet_column <- c(dead_diet_column, dead_diet)
    living_diet_column <- c(living_diet_column, living_diet)
    n=n+1
  }
  # Plot with wavelengths on the x-axis
  subfolder_matrix<-do.call(cbind,data_subfolder)
  matplot(wavelengths, subfolder_matrix, type = "l", col = colors,lty=1,
          xlab = "Wavelength (nm)", ylab = "Reflectance",
          main = paste("Sample spectra (", subfolder_names[i], ") with Reflectance > 0.125 at 987nm"), ylim=c(0,0.3))
  
  #legend("topleft", legend = file_name,cex = 0.5)
  data_subfolder<-list()
  # Transpose the subfolder_matrix
  subfolder_matrix_transposed <- t(subfolder_matrix)
  
  # Set row names as file names and column names as wavelengths
  rownames(subfolder_matrix_transposed) <- file_name
  colnames(subfolder_matrix_transposed) <- as.character(wavelengths)
  # Save the transposed_matrix in a CSV file
  save_path <- file.path(main_folder, paste0("matrix_", subfolder_names[i], ".csv"))
  write.csv(subfolder_matrix_transposed, save_path)
  
}

# You now have a list of data for each CSV file in the folder

# Plot with wavelengths on the x-axis
matrix_spectra <- do.call(cbind, data_list_samples_only)

# Create the plot with matplot specifying the colors
matplot(wavelengths, matrix_spectra,type = "l", col = colors,lty=1,
        xlab = "Wavelength (nm)", ylab = "Reflectance",
        main = "Controll Samples Spectra (Reflectance(987nm) > 0.125)",ylim=c(0,0.3))

# Add a legend with the names of the subfolders
legend("topleft", legend = unique(subfolder_names), fill = colors, cex = 0.5)

# Transpose the matrix_spectra
matrix_spectra_transposed <- t(matrix_spectra)

# Set row names as the names of CSV files
rownames(matrix_spectra_transposed) <- names(data_list_samples_only)
colnames(matrix_spectra_transposed) <- as.character(wavelengths)
print(matrix_spectra_transposed)
dim(matrix_spectra_transposed)
# Save the transposed_matrix in a CSV file
save_path <- file.path(main_folder, "spectra.csv")
write.csv(matrix_spectra_transposed, save_path)

# Create the new matrix classes with the specified columns
classes <- cbind("num_class" = num_class_column, "Dead Diet" = dead_diet_column, "Living Diet" = living_diet_column, "Size" = size_column)
rownames(classes)<- names(data_list_samples_only)
#Save the classes matrix to a CSV file
classes_save_path <- file.path(main_folder, "classes.csv")
write.csv(classes, classes_save_path)
