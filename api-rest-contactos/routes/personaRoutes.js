const express = require('express');
const router = express.Router();
const {
  obtenerPersonas,
  crearPersona,
  actualizarPersona,
  eliminarPersona
} = require('../controllers/personaController');

// Rutas CRUD
router.get('/', obtenerPersonas);
router.post('/', crearPersona);
router.put('/:id', actualizarPersona);
router.delete('/:id', eliminarPersona);

module.exports = router;
