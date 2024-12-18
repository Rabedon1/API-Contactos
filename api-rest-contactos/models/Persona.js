const mongoose = require('mongoose');

const personaSchema = new mongoose.Schema({
  nombre: { type: String, required: true },
  apellido: { type: String, required: true },
  telefono: { type: String, required: true }
}, { timestamps: true }); // timestamps agrega createdAt y updatedAt automáticamente

module.exports = mongoose.model("Persona", personaSchema);
