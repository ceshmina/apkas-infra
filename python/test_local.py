from lambda_function import resize, extract_exif


def main():
    resize('sample/01_original.jpg', 'sample/01_medium.webp', 1920)
    resize('sample/01_original.jpg', 'sample/01_thumbnail.webp', 240)
    extract_exif('sample/01_original.jpg', 'sample/01_exif.json')

    resize('sample/02_original.jpg', 'sample/02_large.webp', 3840)
    resize('sample/02_original.jpg', 'sample/02_thumbnail.webp', 240)


if __name__ == '__main__':
    main()
