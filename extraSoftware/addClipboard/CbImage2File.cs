using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CbImage2File
{
    class Program
    {
        private static int FAILURE = 1;

        private static void Failure(string description)
        {
            Console.Error.WriteLine("Clipboard does not contain image data");
            Environment.Exit(FAILURE);
        }

        [STAThread]
        static void Main(string[] args)
        {
            var image = System.Windows.Forms.Clipboard.GetImage();

            if (image == null)
            {
                Failure("Clipboard does not contain image data");
            }

            if (args.Length == 0)
            {
                Failure("You have not specified an output path for the image");
            }

            if (args.Length > 1)
            {
                Failure("You must only specify a file path (1 argument)");
            }

            var filePath = args[0];
            var folderInfo = new System.IO.FileInfo(filePath).Directory;

            if (!folderInfo.Exists)
            {
                System.IO.Directory.CreateDirectory(folderInfo.FullName);
            }

            image.Save(filePath);
        }
    }
}
