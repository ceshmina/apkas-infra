import json

import boto3
from PIL import Image
from PIL.ExifTags import TAGS
from PIL.TiffImagePlugin import IFDRational


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


def extract_exif(input_path: str, output_path: str):
    image = Image.open(input_path)
    exif_raw = image._getexif()

    def _format_value(value):
        if isinstance(value, bytes):
            return value.decode('utf-8')
        if isinstance(value, IFDRational):
            return value.numerator / value.denominator
        if isinstance(value, tuple):
            return [_format_value(v) for v in value]
        return value

    exif = { TAGS.get(tag, tag): _format_value(value) for tag, value in exif_raw.items() }
    with open(output_path, 'w') as f:
        json.dump(exif, f, indent=2)


def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    if 'original' not in key or not key.endswith('.jpg'):
        return
    
    filename = key.rsplit('/', 1)[1].rsplit('.', 1)[0]
    original_path = f'/tmp/{filename}.jpg'
    s3_client = boto3.client('s3')
    s3_client.download_file(bucket, key, original_path)

    large_path = f'/tmp/{filename}_large.webp'
    medium_path = f'/tmp/{filename}_medium.webp'
    thumbnail_path = f'/tmp/{filename}_thumbnail.webp'
    exif_path = f'/tmp/{filename}_exif.json'

    resize(original_path, large_path, 3840)
    resize(original_path, medium_path, 1920)
    resize(original_path, thumbnail_path, 240)
    extract_exif(original_path, exif_path)

    large_key = key.replace('original', 'large').replace('.jpg', '.webp')
    medium_key = key.replace('original', 'medium').replace('.jpg', '.webp')
    thumbnail_key = key.replace('original', 'thumbnail').replace('.jpg', '.webp')
    exif_key = key.replace('original', 'exif').replace('.jpg', '.json')

    s3_client.upload_file(large_path, bucket, large_key)
    s3_client.upload_file(medium_path, bucket, medium_key)
    s3_client.upload_file(thumbnail_path, bucket, thumbnail_key)
    s3_client.upload_file(exif_path, bucket, exif_key)
