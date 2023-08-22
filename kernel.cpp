void printf(char *text)
{
    unsigned short *VideoMemory;
    VideoMemory = (unsigned short *)0xb8000;

    for (int i = 0; text[i] != '\0'; ++i)
    {
        // modify the display content on a VGA text mode screen
        // we only want high byte
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | text[i];
    }
}
void main(void *multi_boot_structure, unsigned int magic_number)
{
    printf("Hello World");

    // Go into an infinite loop, do not kill kernel
    while (1)
        ;
}