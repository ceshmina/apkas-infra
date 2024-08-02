from PIL import Image


def resize(input_path: str, output_path: str, size: int):
    image = Image.open(input_path)
    width, height = image.size
    if width > height:
        new_width = size
        new_height = int(size * height / width)
    else:
        new_height = size
        new_width = int(size * width / height)
    resized = image.resize((new_width, new_height))
    resized.save(output_path)


def crop_center(input_path: str, output_path: str):
    image = Image.open(input_path)
    width, height = image.size
    if width > height:
        new_height = height
        new_width = height
    else:
        new_width = width
        new_height = width
    left = (width - new_width) // 2
    right = left + new_width
    top = (height - new_height) // 2
    bottom = top + new_height
    cropped = image.crop((left, top, right, bottom))
    cropped.save(output_path)
