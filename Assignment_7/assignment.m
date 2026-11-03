close all;

%{
 For grayscale dot mosaic
im = im2double(rgb2gray(imread('.....')));
% resize if necessary
im = imresize(im,0.5);
mosaic = dot_mosaic_gray(im, 35);  % Choose Size carefully!
figure; montage({im, mosaic});

% For color dot mosaic
im = im2double(imread('.....'));
% resize if necessary
im = imresize(im,0.5);
mosaic = dot_mosaic_color(im, 50);  % Choose Size carefully!
figure; montage({im, mosaic});
%}


% FIRST TWO IMAGE FROM INTERNET, OTHER ARE PERSONAL IMAGE 
baseURL = 'https://raw.githubusercontent.com/XiaomengLiu6/572-photos/main/Assignment_7/';

%% Image 1: Apple (color)
im = im2double(imread([baseURL, 'apple.jpeg']));
im = imresize(im, 0.5);

Size = 30;
mosaic = dot_mosaic_color(im, Size);

figure;
montage({im, mosaic});
title('Image 1: Apple - Grayscale');


%% Image 2: Buffalo (Grayscale)
im = im2double(rgb2gray(imread([baseURL, 'buffalo.jpeg'])));
im = imresize(im, 0.5);

Size = 30;
mosaic = dot_mosaic_gray(im, Size);

figure;
montage({im, mosaic});
title('Image 2: Buffalo - Grayscale');


%% Image 3: Building (Grayscale)
im = im2double(rgb2gray(imread([baseURL, 'building.jpeg'])));
im = imresize(im, 0.5);

Size = 30;
mosaic = dot_mosaic_gray(im, Size);

figure;
montage({im, mosaic});
title('Image 3: Building - Grayscale');


%% Image 4: Cat (Color)
im = im2double(imread([baseURL, 'cat.jpeg']));
im = imresize(im, 0.5);

Size = 40;
mosaic = dot_mosaic_color(im, Size);

figure;
montage({im, mosaic});
title('Image 4: Cat - Color');


%% Image 5: Disney (Grayscale)
im = im2double(rgb2gray(imread([baseURL, 'disney.jpeg'])));
im = imresize(im, 0.5);

Size = 35;
mosaic = dot_mosaic_gray(im, Size);

figure;
montage({im, mosaic});
title('Image 5: Disney - Color');


%% Image 6: Giraffe (Color)
im = im2double(imread([baseURL, 'giraffe.jpeg']));
im = imresize(im, 0.5);

Size = 45;
mosaic = dot_mosaic_color(im, Size);

figure;
montage({im, mosaic});
title('Image 6: Giraffe - Color');


function result = dot_mosaic_gray(im, Size)
    [h, w] = size(im);

    % Grid square size: odd and at least 3
    k = max(3, 2 * round((min(h,w)/Size - 1)/2) + 1);

    % Reduce image to one pixel per dot
    small = imresize(im, 1/k);
    [rows, cols] = size(small);

    mosaic = cell(rows, cols);

    for i = 1:rows
        for j = 1:cols
            % Start with a white square
            square = ones(k, k);

            % Darker pixels produce larger dots
            value = small(i,j);

            if value < 1
                radius = ((k-1)/2) * sqrt(1-value);

                % Create and normalize disk
                disk = fspecial('disk', radius);
                disk = disk / max(disk(:));
                disk = 1 - disk;

                % Center disk in the white square
                d = size(disk,1);
                start = floor((k-d)/2) + 1;
                square(start:start+d-1, start:start+d-1) = disk;
            end

            mosaic{i,j} = square;
        end
    end

    result = cell2mat(mosaic);
end

function result = dot_mosaic_color(im, Size)
    % Apply grayscale method to each color channel
    red = dot_mosaic_gray(im(:,:,1), Size);
    green = dot_mosaic_gray(im(:,:,2), Size);
    blue = dot_mosaic_gray(im(:,:,3), Size);

    % Combine RGB channels
    result = cat(3, red, green, blue);
end
