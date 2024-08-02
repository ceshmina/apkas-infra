from lambda_function import resize, crop_center, extract_exif


def main():
    resize('sample/01_original.jpg', 'sample/01_medium.webp', 2048)
    crop_center('sample/01_original.jpg', 'sample/01_thumbnail.webp')
    resize('sample/01_thumbnail.webp', 'sample/01_thumbnail.webp', 256)
    extract_exif('sample/01_original.jpg', 'sample/01_exif.json')

    resize('sample/02_original.jpg', 'sample/02_large.webp', 4096)
    crop_center('sample/02_original.jpg', 'sample/02_thumbnail.webp')
    resize('sample/02_thumbnail.webp', 'sample/02_thumbnail.webp', 256)


if __name__ == '__main__':
    main()
