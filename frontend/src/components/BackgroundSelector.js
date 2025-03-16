import React from 'react';
import {
  SimpleGrid,
  Box,
  Image,
  Text,
  useColorModeValue,
} from '@chakra-ui/react';

const BackgroundSelector = ({ backgrounds, selectedBackground, onSelect }) => {
  const borderColor = useColorModeValue('gray.200', 'gray.600');
  const selectedBorderColor = 'rcb.red';
  const bgColor = useColorModeValue('white', 'gray.700');
  const selectedBgColor = useColorModeValue('gray.50', 'gray.600');

  if (!backgrounds || backgrounds.length === 0) {
    return (
      <Box textAlign="center" py={4}>
        <Text color="gray.500">No background images available</Text>
      </Box>
    );
  }

  return (
    <SimpleGrid columns={2} spacing={4}>
      {backgrounds.map((bg) => (
        <Box
          key={bg.name}
          borderWidth={2}
          borderRadius="md"
          borderColor={
            selectedBackground === bg.name ? selectedBorderColor : borderColor
          }
          bg={selectedBackground === bg.name ? selectedBgColor : bgColor}
          p={2}
          cursor="pointer"
          onClick={() => onSelect(bg.name)}
          transition="all 0.2s"
          _hover={{
            borderColor: selectedBorderColor,
          }}
          position="relative"
        >
          <Image
            src={bg.preview}
            alt={bg.name}
            borderRadius="md"
            objectFit="cover"
            width="100%"
            height="100px"
          />
          <Text
            fontSize="xs"
            mt={1}
            textAlign="center"
            fontWeight={selectedBackground === bg.name ? 'bold' : 'normal'}
            color={selectedBackground === bg.name ? 'rcb.red' : 'gray.600'}
            isTruncated
          >
            {bg.name.split('.')[0]}
          </Text>
          {selectedBackground === bg.name && (
            <Box
              position="absolute"
              top={2}
              right={2}
              bg="rcb.red"
              borderRadius="full"
              w={4}
              h={4}
            />
          )}
        </Box>
      ))}
    </SimpleGrid>
  );
};

export default BackgroundSelector; 