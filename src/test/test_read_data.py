import unittest
from io import StringIO

import pandas as pd

from utils.extraction import DataProcessor


class TestDataProcessor(unittest.TestCase):
    """Pruebas unitarias para la clase DataProcessor."""

    def setUp(self):
        """
        setUp Configura los datos de prueba antes de cada test.

        Crea datos de prueba simulados en formato CSV.
        """
        self.sample_csv = StringIO(
            """Fecha,Valor
            01/01/23,100
            15/01/23,200
            01/02/23,300
            """
        )
        self.file_path = "dummy.csv"
        self.date_column = "Fecha"
        self.date_format = "%d/%m/%y"

    def test_load_data(self):
        """Prueba que los datos se carguen correctamente desde un archivo."""
        processor = DataProcessor(
            file_path=self.file_path,
            date_column=self.date_column,
            date_format=self.date_format,
        )
        processor.data = pd.read_csv(self.sample_csv, sep=",")
        self.assertIsNotNone(processor.data)
        self.assertEqual(len(processor.data), 3)  # Asegura que hay 3 filas

    def test_process_dates(self):
        """Prueba que las fechas se procesen correctamente."""
        processor = DataProcessor(
            file_path=self.file_path,
            date_column=self.date_column,
            date_format=self.date_format,
        )
        processor.data = pd.read_csv(self.sample_csv, sep=",")
        processor.process_dates()
        self.assertIn("FechaMensual", processor.data.columns)
        self.assertEqual(
            processor.data.index.name, self.date_column
        )  # Asegura que la columna de fecha es el índice

    def test_get_data(self):
        """Prueba que get_data devuelva el DataFrame procesado."""
        processor = DataProcessor(
            file_path=self.file_path,
            date_column=self.date_column,
            date_format=self.date_format,
        )
        processor.data = pd.read_csv(self.sample_csv, sep=",")
        processor.process_dates()
        data = processor.get_data()
        self.assertIsInstance(data, pd.DataFrame)
        self.assertEqual(len(data), 3)

    def test_load_data_raises_file_not_found_error(self):
        """Prueba que se levante FileNotFoundError si el archivo no existe."""
        processor = DataProcessor(
            file_path="non_existent_file.csv",
            date_column=self.date_column,
            date_format=self.date_format,
        )
        with self.assertRaises(FileNotFoundError):
            processor.load_data()

    def test_process_dates_raises_value_error(self):
        """Prueba que se levante ValueError si los datos no se han cargado."""
        processor = DataProcessor(
            file_path=self.file_path,
            date_column=self.date_column,
            date_format=self.date_format,
        )
        with self.assertRaises(ValueError):
            processor.process_dates()

    def test_get_data_raises_value_error(self):
        """Prueba que se levante ValueError si el DataFrame no está procesado."""
        processor = DataProcessor(
            file_path=self.file_path,
            date_column=self.date_column,
            date_format=self.date_format,
        )
        with self.assertRaises(ValueError):
            processor.get_data()


if __name__ == "__main__":
    unittest.main()
