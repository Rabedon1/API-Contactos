const Persona = require('../models/Persona');

// Obtener todas las personas
exports.obtenerPersonas = async (req, res) => {
  try {
    const personas = await Persona.find();
    res.json(personas);
  } catch (error) {
    res.status(500).json({ message: "Error al obtener personas", error });
  }
};

// Crear una nueva persona
exports.crearPersona = async (req, res) => {
  try {
    const nuevaPersona = new Persona(req.body);
    const personaGuardada = await nuevaPersona.save();
    res.status(201).json(personaGuardada);
  } catch (error) {
    res.status(400).json({ message: "Error al crear persona", error });
  }
};

// Actualizar una persona
exports.actualizarPersona = async (req, res) => {
  try {
    const personaActualizada = await Persona.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!personaActualizada) return res.status(404).json({ message: "Persona no encontrada" });
    res.json(personaActualizada);
  } catch (error) {
    res.status(400).json({ message: "Error al actualizar persona", error });
  }
};

// Eliminar una persona
exports.eliminarPersona = async (req, res) => {
  try {
    const personaEliminada = await Persona.findByIdAndDelete(req.params.id);
    if (!personaEliminada) return res.status(404).json({ message: "Persona no encontrada" });
    res.json({ message: "Persona eliminada exitosamente" });
  } catch (error) {
    res.status(500).json({ message: "Error al eliminar persona", error });
  }
};
