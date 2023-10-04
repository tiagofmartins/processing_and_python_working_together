import os, time
from PIL import Image

this_script_dir = os.path.abspath(os.path.dirname(__file__))
path_file_images_paths = os.path.join(this_script_dir, 'images_paths.txt')
path_file_images_fitness = os.path.join(this_script_dir, 'images_fitness.txt')

def evaluate_image(img_path):
    # ---------- Replace the code below with your fitness function
    img = Image.open(img_path)
    img = img.convert('L')
    count = 0
    for x in range(img.width):
        for y in range(img.height):
            if img.getpixel((x, y)) < 128:
                count += 1
    fitness = count / (img.width * img.height)
    # ---------- Replace the code above with your fitness function
    return fitness

if __name__ == '__main__':
    try:
        print('Waiting for images')
        while True:
            if os.path.exists(path_file_images_paths) and os.path.isfile(path_file_images_paths):
                print('Evaluating images')

                # Get images paths
                with open(path_file_images_paths) as f:
                    images_paths = [line.strip() for line in f]
                
                # Calculate fitness values
                images_fitness = [evaluate_image(img_path) for img_path in images_paths]

                # Save fitness values to file
                assert not os.path.exists(path_file_images_fitness)
                with open(path_file_images_fitness, 'w') as f:
                    f.write('\n'.join([str(v) for v in images_fitness]))
                
                # Remove file with images paths
                os.remove(path_file_images_paths)

                print('Waiting for images')
            time.sleep(0.5)
    except KeyboardInterrupt:
        pass