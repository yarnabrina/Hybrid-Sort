#include < Rcpp.h >
using namespace Rcpp;

// function to interchange elements of an array at two positions
void swap(NumericVector array, int first_position, int second_position) {
    double temporary = array[first_position];
    array[first_position] = array[second_position];
    array[second_position] = temporary;
}

// function to calculate median of the first, last middlemost elements of an array
int median_of_three(NumericVector array, int start, int end) {
    int middle = (start + end) / 2;
    if (array[start] > array[end]) {
        swap(array, start, end);
    }
    if (array[middle] > array[end]) {
        swap(array, middle, end);
    }
    if (array[start] > array[middle]) {
        swap(array, start, middle);
    }
    return middle;
}

// partition algorithm for quick sort using first element as pivot
int partition_hoare(NumericVector array, int start, int end) {
    double pivot = array[start];
    int i = (start - 1);
    int j = (end + 1);
    while (TRUE) {
        do {
            i = (i + 1);
        } while (array[i] < pivot);
        do {
            j = (j - 1);
        } while (array[j] > pivot);
        if (i >= j) {
            return j;
        }
        swap(array, i, j);
    }
}

// partition algorithm for quick sort using last element as pivot
int partition_lomuto(NumericVector array, int start, int end) {
    double pivot = array[end];
    int i = (start - 1);
    for (int j = start; j < end; ++j) {
        if (array[j] <= pivot) {
            i = (i + 1);
            swap(array, i, j);
        }
    }
    swap(array, (i + 1), end);
    return (i + 1);
}

// partition algorithm for quick sort using random element as pivot
int partition_lomuto_random(NumericVector array, int start, int end) {
    int key = rand() % (end - start + 1) + start;
    swap(array, key, end);
    return partition_lomuto(array, start, end);
}

// partition algorithm for quick sort using median of first, last and middlemost elements as pivot
int partition_hoare_singleton(NumericVector array, int start, int end) {
    int key = median_of_three(array, start, end);
    swap(array, start, key);
    return partition_hoare(array, start, end);
}

// insertion sort algorithm
void insertion(NumericVector array, int start, int end) {
    if (start < end) {
        for (int i = (start + 1); i <= end; ++i) {
            double temporary = array[i];
            int j = (i - 1);
            while ((j >= start) && (array[j] > temporary)) {
                array[(j + 1)] = array[j];
                j = (j - 1);
            }
            array[(j + 1)] = temporary;
        }
    }
}

// quick sort algorithm using first element as pivot
void quick_hoare(NumericVector array, int start, int end) {
    if (start < end) {
        int key = partition_hoare(array, start, end);
        quick_hoare(array, start, key);
        quick_hoare(array, (key + 1), end);
    }
}

// quick sort algorithm using median of three pivot
void quick_hoare_singleton(NumericVector array, int start, int end) {
    if (start < end) {
        int key = partition_hoare_singleton(array, start, end);
        quick_hoare_singleton(array, start, key);
        quick_hoare_singleton(array, (key + 1), end);
    }
}

// hybrid sort algorithm using first element as pivot
void hybrid_hoare(NumericVector array, int start, int end, int cutoff) {
    if (start < end) {
        // applying partition algorithm only when array size is more than cutoff
        if ((end - start + 1) > cutoff) {
            int key = partition_hoare(array, start, end);
            hybrid_hoare(array, start, key, cutoff);
            hybrid_hoare(array, (key + 1), end, cutoff);
        }
    }
}

// hybrid sort algorithm using random element as pivot
void hybrid_lomuto_random(NumericVector array, int start, int end, int cutoff) {
    if (start < end) {
        // applying partition algorithm only when array size is more than cutoff
        if ((end - start + 1) > cutoff) {
            int key = partition_lomuto_random(array, start, end);
            hybrid_lomuto_random(array, start, key, cutoff);
            hybrid_lomuto_random(array, (key + 1), end, cutoff);
        }
    }
}

// [[Rcpp::export]]
// function to be called from R to use the sorting algorithms defined above
NumericVector sorting_R(NumericVector array, int method = 1, int cutoff) {
    int n = array.length();
    // making an explicit copy of the input array to keep that unchanged
    NumericVector sorted_array = clone(array);
    // applying different sorting algorithms based on user input on method
    switch (method) {
    case 1:
        {
            hybrid_hoare(sorted_array, 0, (n - 1), cutoff);
            insertion(sorted_array, 0, (n - 1));
            break;
        }
    case 2:
        {
            hybrid_lomuto_random(sorted_array, 0, (n - 1), cutoff);
            insertion(sorted_array, 0, (n - 1));
            break;
        }
    case 3:
        {
            insertion(sorted_array, 0, (n - 1));
            break;
        }
    case 4:
        {
            quick_hoare(sorted_array, 0, (n - 1));
            break;
        }
    case 5:
        {
            quick_hoare_singleton(sorted_array, 0, (n - 1));
            break;
        }
    default:
        {
            Rcpp::stop("Permissible values are 1 to 5", FALSE);
        }
    }
    return sorted_array;
}
