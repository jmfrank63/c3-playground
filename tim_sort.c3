module tim_sort;
import std::io;

// TimSort implementation
fn void insertion_sort(int[] arr, int left, int right) {
    for (int i = left + 1; i <= right; i++) {
        int temp = arr[i];
        int j = i - 1;
        while (j >= left && arr[j] > temp) {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = temp;
    }
}

fn void merge(int[] arr, int left, int mid, int right) {
    int len1 = mid - left + 1;
    int len2 = right - mid;
    
    // Create temporary arrays using array literals
    int[] leftArr = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; // Using a fixed size for simplicity
    int[] rightArr = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; // Assume reasonable max size

    for (int i = 0; i < len1; i++) {
        leftArr[i] = arr[left + i];
    }
    for (int i = 0; i < len2; i++) {
        rightArr[i] = arr[mid + 1 + i];
    }

    // Initialize variables separately
    int i = 0;
    int j = 0;
    int k = left;
    
    while (i < len1 && j < len2) {
        if (leftArr[i] <= rightArr[j]) {
            arr[k] = leftArr[i];
            i++;
        } else {
            arr[k] = rightArr[j];
            j++;
        }
        k++;
    }

    while (i < len1) {
        arr[k] = leftArr[i];
        i++;
        k++;
    }

    while (j < len2) {
        arr[k] = rightArr[j];
        j++;
        k++;
    }
}

fn void tim_sort(int[] arr, int n) {
    int run = 32;

    for (int i = 0; i < n; i += run) {
        insertion_sort(arr, i, (i + run - 1 < n - 1) ? (i + run - 1) : (n - 1));
    }

    for (int size = run; size < n; size = 2 * size) {
        for (int left = 0; left < n; left += 2 * size) {
            int mid = left + size - 1;
            int right = (left + 2 * size - 1 < n - 1) ? (left + 2 * size - 1) : (n - 1);

            if (mid < right) {
                merge(arr, left, mid, right);
            }
        }
    }
}

fn int min(int a, int b) {
    return a < b ? a : b;
}

fn void main() {
    int[6] arr = { 5, 2, 9, 1, 5, 6 };
    int n = 6;

    io::printn("Original array:");
    for (int i = 0; i < n; i++) {
        io::printn(arr[i]);
    }

    // Pass array as a slice using arr[..]
    tim_sort(arr[..], n);

    io::printn("\nSorted array:");
    for (int i = 0; i < n; i++) {
        io::printn(arr[i]);
    }
}